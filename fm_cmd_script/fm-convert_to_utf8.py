#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
convert_to_utf8.py —— 批量把「含中文乱码」的非 UTF-8 文本文件转换成 UTF-8

为什么需要它：Windows 下用 Keil / Source Insight / 记事本写出来的 .c/.h 注释常常是
GB2312/GBK 编码，在 VSCode、CLion、Git diff、DSH 这类按 UTF-8 解码的编辑器里就显示成
"ä½ å¥½" 之类的乱码。本脚本扫描目录，识别这些文件并原地转成 UTF-8。

它区分的两类"乱码"（这是最容易搞错的地方）：
  1. 真正的中文乱码：文件是 GBK/GB2312/Big5 编码  ->  按 gb18030/big5 解码后转 UTF-8
  2. 假乱码：文件其实是 CP1252/Windows-1252 的英文原文，只是含 ’ “ ” – ° µ 这类
     排版字符（0x80-0x9F 区）。这类文件若当成 GBK 解码会得到"peripheral抯 drivers"
     这种伪汉字。默认不处理，需要显式加 --western。
  两类靠"连续汉字长度"区分：真中文几乎必然出现连续 2 个以上汉字/中文标点，
  而伪汉字永远是孤立单字。

用法速览：
  # 1) 只处理点名指定的文件（可多个文件、可文件与目录混写）
  python3 tools/convert_to_utf8.py app/main.c board/board.c bsp/uart/bsp_uart.c

  # 1b) 从清单文件读（每行一个路径，# 注释；- 表示标准输入）
  python3 tools/convert_to_utf8.py --files-from list.txt --realdo

  # 1c) 通配符（脚本内部展开，Windows 下也能用；支持 ** 递归）
  python3 tools/convert_to_utf8.py 'project_*/board/*.h' '*/bsp/**/*.c'

  # 1d) 扫目录但排除干扰项
  python3 tools/convert_to_utf8.py . --exclude '*/libraries/*' --exclude build

  # 1e) 先只列出"会被转换的文件"，确认后再动手
  python3 tools/convert_to_utf8.py . --list | tee list.txt

  # 2) 先看报告，不写任何文件（默认就是 dry-run）
  python3 tools/convert_to_utf8.py project_build4_stm32f407_demo

  # 2) 确认后执行转换（默认自动备份到 .utf8_backup/，可一键回退）
  python3 tools/convert_to_utf8.py project_build4_stm32f407_demo --realdo

  # 3) 连"假乱码"（CP1252 英文排版字符）一起处理
  python3 tools/convert_to_utf8.py project_build4_stm32f407_demo --western --realdo

  # 4) 提交前自检：还有没有非 UTF-8 的中文文件（有则退出码 1，可用于 CI/钩子）
  python3 tools/convert_to_utf8.py . --check

  # 5) 回退
  python3 tools/convert_to_utf8.py --revert .utf8_backup

  # 6) 自测（在临时目录里造样例文件跑全流程）
  python3 tools/convert_to_utf8.py --self-test

  # 7) 给 CI 用的机器可读报告（- 表示写到标准输出），-q 只留汇总行
  python3 tools/convert_to_utf8.py . --json report.json -q

退出码：0 正常（含 dry-run 有发现） / 1 --check 失败 / 2 用法错误（未给路径、
路径不存在、参数冲突） / 3 转换过程中有文件失败。

安全性：只有显式加 --realdo 才会写文件，默认 dry-run（也可显式写 --dry-run）；
不带路径时只打印帮助，绝不隐式扫描当前目录；写文件前先备份原件；转换后校验
「utf-8 解码结果再按源编码编码回去 == 原始字节」以及
「非 ASCII 字节滤掉后的 ASCII 骨架逐字节不变」，因此代码逻辑不可能被改动。
中文若出现在字符串字面量里会额外用 ⚠ 标注（那会改变串口输出字节）。
"""

from __future__ import annotations

import argparse
import collections
import fnmatch
import glob as globlib
import hashlib
import os
import re
import shutil
import subprocess
import sys
import tempfile
import unicodedata
from dataclasses import dataclass, field
from pathlib import Path

VERSION = "1.0.0"

# --------------------------------------------------------------------------
# 常量
# --------------------------------------------------------------------------

#: 默认跳过的目录名
SKIP_DIRS = {
    ".git", ".svn", ".hg", "node_modules", "__pycache__", ".idea", ".vscode",
    "build", "Build", "BUILD", "out", "Debug", "Release", "CMakeFiles",
    "Objects", "Listings", ".utf8_backup", ".utf8_migration_backup",
}

#: 明确的二进制后缀（不读内容直接跳过）
BINARY_EXT = {
    ".bmp", ".png", ".jpg", ".jpeg", ".gif", ".ico", ".tif", ".tiff", ".webp",
    ".pdf", ".chm", ".zip", ".rar", ".7z", ".gz", ".bz2", ".xz", ".tar",
    ".exe", ".dll", ".so", ".dylib", ".a", ".lib", ".o", ".obj", ".bin",
    ".hex", ".elf", ".axf", ".map", ".pyc", ".class", ".jar", ".db", ".sqlite",
    ".xls", ".xlsx", ".doc", ".docx", ".ppt", ".pptx", ".mp3", ".wav", ".mp4",
    ".ttf", ".otf", ".woff", ".woff2", ".eot", ".psd", ".ai", ".lib", ".uvguix",
}

#: 带 charset 声明的标记语言（转换时同步改声明）
MARKUP_EXT = {".html", ".htm", ".xhtml"}

#: quoted-printable 归档（如 Word 另存的 .mht），默认不碰
MHT_EXT = {".mht", ".mhtml"}

#: 可能含字符串字面量的源码后缀（用于 ⚠ 提示）
CODE_EXT = {
    ".c", ".h", ".cpp", ".hpp", ".cc", ".cxx", ".hxx", ".inl", ".ipp",
    ".py", ".js", ".ts", ".jsx", ".tsx", ".java", ".cs", ".go", ".rs", ".rb",
    ".php", ".pl", ".lua", ".m", ".mm", ".swift", ".kt", ".scala", ".sh",
    ".bash", ".bat", ".ps1", ".sql", ".ld", ".s", ".asm", ".ino", ".cmake",
}

#: 候选源编码（按顺序尝试）。gb18030 是 GB2312/GBK 的超集，能解出 GBK 就一定能解出它。
CHINESE_ENCODINGS = ("gb18030", "big5")
WESTERN_ENCODINGS = ("cp1252", "latin-1")

#: 判定"西方排版字符"的白名单：CP1252 里除拉丁字母外常见的符号/标点
WESTERN_PUNCT = set(
    "\u2018\u2019\u201a\u201b\u201c\u201d\u201e\u201f"   # 弯引号
    "\u2013\u2014\u2015\u2026\u2022\u2020\u2021"          # 破折号/省略号/项目符号
    "\u00a0\u00a9\u00ae\u2122\u00a7\u00b6\u00b0\u00b5"    # NBSP © ® ™ § ¶ ° µ
    "\u00b1\u00d7\u00f7\u00a1\u00bf\u00ab\u00bb\u2039\u203a"
    "\u20ac\u00a3\u00a5\u00a2\u0192\u02c6\u02dc\u0160\u0161\u017d\u017e\u0152\u0153\u0178"
)

#: 严格汉字（统计个数用）
IDEOGRAPH_RE = re.compile(r"[\u3400-\u4dbf\u4e00-\u9fff\uf900-\ufaff]")
#: 连续的中文/中文标点段落（求最长连续长度用；中文标点算在内，
#: 这样"值，"算连续 2，而西文里被误读出的孤立伪汉字只有 1）
CJK_RUN_RE = re.compile(
    r"[\u3400-\u4dbf\u4e00-\u9fff\uf900-\ufaff\u3000-\u303f\uff00-\uffef]+"
)

#: "双重编码"乱码的强特征（GBK 解 UTF-8 后的替换字 U+9500/U+65A4/U+62F7 等），
#: 正常文档不会成片出现。这里刻意用 \u 转义书写：源码本身若含这些字面量，
#: 扫描自己的源码时就会自己命中自己。
MOJIBAKE_STRONG = ("\u9500\u65a4\u62f7", "\u70eb\u70eb\u70eb")
#: 连片形态（真乱码文件里每个坏字都变成一组特征字，必然重复）
MOJIBAKE_PAIR = tuple(m * 2 for m in MOJIBAKE_STRONG)
#: "双重编码"乱码的弱特征：UTF-8 文本被按 Latin-1/CP1252 读后留下的西欧字母+排版符号。
#: 关键在"连片"——乱码里每个 UTF-8 字节都会变成这类字符，于是成串出现；
#: 而正常文档（含已正确转好的 CP1252 原文，如 ’ “ ” – ° ©）里它们是孤立的，
#: 所以按最长连片判断，而不是按数量密度（密度会误报正常文件）。
#: 阈值 3：真乱码样例最长连片 8，正确文件最长连片 1。
MOJIBAKE_LATIN1_RUN_RE = re.compile(
    r"[\u00a0-\u00ff\u2013-\u203a\u20ac\u2122\u0160-\u0178\u02c6\u02dc]{3,}"
)

#: 编码 -> 常见 charset 声明写法
CHARSET_ALIAS = {
    "gb18030": ("gb2312", "gbk", "gb18030", "x-gbk"),
    "big5": ("big5", "x-x-big5"),
    "cp1252": ("windows-1252", "cp1252", "iso-8859-1", "latin1", "iso8859-1"),
}

UTF8_BOM = b"\xef\xbb\xbf"

#: 备份目录里的标记文件：扫描时据此整棵跳过自己的备份（哪怕换了 --backup-dir 名字、
#: 或下一次运行时没带同样的参数）
BACKUP_MARKER = ".utf8_backup_marker"
BACKUP_MARKER_TEXT = (
    "This directory holds originals backed up by tools/convert_to_utf8.py.\n"
    "扫描时会整棵跳过本目录；删除本文件即可让它重新参与扫描。\n"
)

#: 删掉所有 ASCII 字节即可用 len() 得到非 ASCII 字节数（C 层，比生成器快一个数量级）
ASCII_DELETE = bytes(range(128))
#: 只留下"二进制嫌疑"控制字节的删除表（配合 bytes.translate 统计）
BINARY_PROBE_DELETE = bytes(
    b for b in range(256) if not (b < 0x09 or 0x0E <= b < 0x20)
)

#: CP1252/Latin-1 里"西方排版字符 + 拉丁字母"的允许集合，其余非 ASCII 视为非西文
ALLOWED_NONASCII = frozenset(
    WESTERN_PUNCT | {chr(c) for c in range(0xA0, 0x0250) if chr(c).isalpha()}
)
NONWESTERN_RE = re.compile(
    "[^\x00-\x7f" + re.escape("".join(sorted(ALLOWED_NONASCII))) + "]"
)


# --------------------------------------------------------------------------
# 数据结构
# --------------------------------------------------------------------------

@dataclass
class Info:
    """单个文件的检测结果。"""
    path: Path
    rel: str
    size: int
    kind: str = "unknown"          # ascii/utf-8/chinese/western/ambiguous/unknown/
                                   # binary/skipped/empty/utf-16/mojibake-suspect
    encoding: str | None = None    # 判定出的源编码
    cjk: int = 0                   # 汉字个数
    run: int = 0                   # 最长连续中文长度
    nonascii: int = 0              # 非 ASCII 字节数
    in_literal: int = 0            # 非 ASCII 出现在字符串/字符字面量里的次数
    action: str = "跳过"
    note: str = ""
    explicit: bool = False         # 是否用户在命令行/清单里点名指定
    converted: bool = False

    @property
    def ok(self) -> bool:
        return self.kind in ("ascii", "utf-8")


@dataclass
class Options:
    realdo: bool = False
    western: bool = False
    ambiguous: str = "skip"        # skip / chinese / western
    encodings: tuple[str, ...] = ()  # 强制指定源编码（覆盖自动判定）
    min_run: int = 2               # 判定"真中文"的最短连续长度
    exts: set[str] = field(default_factory=set)
    excludes: tuple[str, ...] = ()           # --exclude 通配符（扫目录时按路径过滤）
    skip_dirs: set[str] = field(default_factory=set)
    exclude_dirs: tuple[Path, ...] = ()      # 整棵子树排除（本次的备份目录）
    include_mht: bool = False
    update_html_charset: bool = True
    strip_bom: bool = False
    max_size: int = 32 * 1024 * 1024
    backup_dir: Path | None = None
    warn_literals: bool = True
    strict: bool = False           # 字面量里有非 ASCII 时不转换
    check: bool = False
    path_width: int = 80
    quiet: bool = False
    list_only: bool = False                  # --list：只输出将被转换的文件路径
    json_path: str | None = None
    verbose: bool = False


# --------------------------------------------------------------------------
# 小工具
# --------------------------------------------------------------------------

def disp_width(s: str) -> int:
    """东亚宽字符按 2 列计算，用于对齐输出。"""
    return sum(2 if unicodedata.east_asian_width(c) in "WF" else 1 for c in s)


def pad(s: str, width: int) -> str:
    return s + " " * max(0, width - disp_width(s))


def elide(s: str, maxw: int) -> str:
    """超宽时保留尾部（尾部信息量更大），前面用 … 省略。"""
    if disp_width(s) <= maxw:
        return s
    out, w = [], 0
    for ch in reversed(s):
        cw = 2 if unicodedata.east_asian_width(ch) in "WF" else 1
        if w + cw > maxw - 1:
            break
        out.append(ch)
        w += cw
    return "…" + "".join(reversed(out))


def sha256(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest()


def count_cjk(text: str) -> tuple[int, int]:
    """
    返回 (汉字个数, 最长连续中文长度)。
    用正则做两趟扫描（都在 C 层跑）：几 MB 的头文件也能毫秒级完成，
    不要改回逐字符 Python 循环——那会让整棵树扫描慢一个数量级。
    """
    if CJK_RUN_RE.search(text) is None:      # 绝大多数文件在这里就结束，不做第二趟
        return 0, 0
    cjk = len(IDEOGRAPH_RE.findall(text))
    longest = 0
    for m in CJK_RUN_RE.finditer(text):
        n = m.end() - m.start()
        if n > longest:
            longest = n
    return cjk, longest


def looks_binary(data: bytes) -> bool:
    """按内容粗判二进制：前 8KB 有 NUL 或控制字符比例过高。"""
    head = data[:8192]
    if b"\x00" in head:
        return True
    if not head:
        return False
    ctrl = len(head.translate(None, BINARY_PROBE_DELETE))   # C 层统计控制字节
    return ctrl / len(head) > 0.10


def mojibake_score(text: str, cjk_run: int) -> tuple[int, str]:
    """
    判断一个"已经是合法 UTF-8"的文件是否其实是双重编码乱码（mojibake）。
    返回 (特征数, 说明)，0 表示不像。
    注意：单看"文件里出现了乱码特征字符串"会误报——本脚本的源码、编码教程
    都会写到这些特征本身；所以强特征只认"连片重复"形态（真乱码文件里
    每个坏字都变成一组特征字，必然成片），弱特征则要求足够密度
    且文件里没有任何连续中文（真乱码文件里中文已经全被打散了）。
    """
    pair = sum(text.count(p) for p in MOJIBAKE_PAIR)
    total = sum(text.count(m) for m in MOJIBAKE_STRONG)
    if pair or total >= 6:
        return max(pair, total), (
            "疑似 GBK 解 UTF-8 的双重编码（连续 %d 处、共 %d 处）" % (pair, total))
    if cjk_run < 2:
        longest = max((m.end() - m.start()
                       for m in MOJIBAKE_LATIN1_RUN_RE.finditer(text)), default=0)
        if longest:
            return longest, ("疑似 Latin-1/CP1252 解 UTF-8 的双重编码"
                             "（出现 %d 个连片西欧字符）" % longest)
    return 0, ""


def count_nonascii(data: bytes) -> int:
    """非 ASCII 字节个数（C 层：删掉 ASCII 后取长度）。"""
    return len(data.translate(None, ASCII_DELETE))


def western_plausible(text: str) -> bool:
    """
    CP1252 读法是否"像正常西文"：非 ASCII 只能是拉丁字母或排版符号。
    用一条正则找第一个"越界字符"，命中即返回（真中文文件会在第一个汉字处立刻失败）。
    """
    return NONWESTERN_RE.search(text) is None


#: 注释或字符串/字符字面量（注释写在前面，保证 // "..." 先被当注释吃掉）
COMMENT_OR_LITERAL_RE = re.compile(
    r"//[^\n]*"
    r"|/\*.*?\*/"
    r'|"(?:\\.|[^"\\\n])*"'
    r"|'(?:\\.|[^'\\\n])*'",
    re.S,
)


def scan_literals(text: str) -> int:
    """
    统计非 ASCII 字符出现在字符串/字符字面量里的次数（C 风格语法足够通用）。
    注释里的中文不算——只有写进字符串的中文才会改变运行期字节（比如串口输出）。
    用正则整体匹配，避免逐字符 Python 循环拖慢整树扫描。
    """
    hits = 0
    for m in COMMENT_OR_LITERAL_RE.finditer(text):
        s = m.group()
        if s[0] in "\"'":
            hits += sum(1 for ch in s if ord(ch) > 127)
    return hits


def rewrite_charset(data: bytes, src_enc: str) -> bytes:
    """把 HTML 里的 charset 声明改成 utf-8（仅 ASCII 区域改动）。"""
    aliases = CHARSET_ALIAS.get(src_enc, (src_enc,))
    text = data.decode("utf-8")
    for alias in aliases:
        text = re.sub(
            r'(charset\s*=\s*["\']?)' + re.escape(alias) + r'(["\'\s;/>])',
            r"\1utf-8\2", text, flags=re.IGNORECASE,
        )
        text = re.sub(
            r'(encoding\s*=\s*["\'])' + re.escape(alias) + r'(["\'])',
            r"\1utf-8\2", text, flags=re.IGNORECASE,
        )
    return text.encode("utf-8")


# --------------------------------------------------------------------------
# 识别
# --------------------------------------------------------------------------

def try_decode(data: bytes, enc: str) -> str | None:
    try:
        return data.decode(enc)
    except (UnicodeDecodeError, LookupError):
        return None


def classify(data: bytes, opts: Options) -> Info:
    """判定一个文件的编码类别。"""
    info = Info(path=Path(), rel="", size=len(data))

    if not data:
        info.kind = "empty"; info.action = "跳过"; info.note = "空文件"
        return info
    if data[:2] in (b"\xff\xfe", b"\xfe\xff"):
        info.kind = "utf-16"; info.note = "疑似 UTF-16，需 --enc utf-16 指定"
        return info

    info.nonascii = count_nonascii(data)

    # 已经是 UTF-8
    text_utf8 = try_decode(data, "utf-8")
    if text_utf8 is not None:
        if info.nonascii == 0:
            info.kind = "ascii"; info.encoding = "ascii"; info.action = "无需处理"
        else:
            info.kind = "utf-8"; info.encoding = "utf-8"; info.action = "无需处理"
            info.cjk, info.run = count_cjk(text_utf8)
            score, why = mojibake_score(text_utf8, info.run)
            if score:
                info.kind = "mojibake-suspect"
                info.note = why
        return info

    # 候选编码逐个试
    decoded: dict[str, str] = {}
    for enc in (*opts.encodings, *CHINESE_ENCODINGS, *WESTERN_ENCODINGS):
        if enc in decoded:
            continue
        t = try_decode(data, enc)
        if t is not None:
            decoded[enc] = t

    # 1) 中文读法
    for enc in (*opts.encodings, *CHINESE_ENCODINGS):
        t = decoded.get(enc)
        if t is None:
            continue
        cjk, run = count_cjk(t)
        info.cjk, info.run = cjk, run
        if cjk and run >= opts.min_run:
            info.kind = "chinese"
            info.encoding = enc
            return info

    # 2) 西文读法（含"假乱码"：孤立伪汉字）
    for enc in (*opts.encodings, *WESTERN_ENCODINGS):
        t = decoded.get(enc)
        if t is None:
            continue
        if western_plausible(t):
            info.kind = "western"
            info.encoding = enc
            # 顺手算出"若按中文编码读会得到几个伪汉字"，写进报告帮人理解判定依据
            for cenc in CHINESE_ENCODINGS:
                ctext = decoded.get(cenc)
                if ctext is None:
                    continue
                cjk, run = count_cjk(ctext)
                info.cjk, info.run = cjk, run
                if cjk:
                    sample = IDEOGRAPH_RE.search(ctext)
                    info.note = "孤立伪汉字 %d 个（如 %s），实为西文排版字符" % (
                        cjk, sample.group() if sample else "?")
                break
            return info

    # 3) 能按中文编码解出字，但不成词 —— 交给人判断
    for enc in (*CHINESE_ENCODINGS,):
        t = decoded.get(enc)
        if t is None:
            continue
        cjk, run = count_cjk(t)
        if cjk:
            info.kind = "ambiguous"
            info.encoding = enc
            info.cjk, info.run = cjk, run
            info.note = "孤立汉字，无法确定是中文还是西文"
            return info

    info.kind = "unknown"
    info.note = "无法按候选编码解码，可能是二进制或冷门编码"
    return info


def iter_files(roots: list[Path], opts: Options):
    """
    产出 (路径, 是否用户点名指定) 二元组。
    点名指定的文件（直接写在命令行/文件列表里）与"扫目录扫出来的"在后续
    过滤规则上待遇不同：前者不受后缀黑/白名单限制，后者才受。
    另外整棵跳过 opts.exclude_dirs（本次的备份目录），否则自定义 --backup-dir
    落在被扫描的树里时，备份副本会被当成"又一个待转换文件"重复统计。
    """
    excl = tuple(os.path.abspath(str(p)) + os.sep for p in opts.exclude_dirs)

    def in_backup(path: str) -> bool:
        return bool(excl) and (os.path.abspath(path) + os.sep).startswith(excl)

    for root in roots:
        if root.is_file():
            if not in_backup(str(root)):
                yield root, True                     # 点名指定
            continue
        for dirpath, dirnames, filenames in os.walk(root):
            keep = []
            for d in sorted(dirnames):
                full = os.path.join(dirpath, d)
                if d in opts.skip_dirs or d.startswith(".utf8_backup"):
                    continue
                if in_backup(full):
                    continue
                if os.path.exists(os.path.join(full, BACKUP_MARKER)):
                    continue          # 这是本工具的备份目录（可能来自上一次运行）
                keep.append(d)
            dirnames[:] = keep
            for name in sorted(filenames):
                full = os.path.join(dirpath, name)
                if in_backup(full):
                    continue
                if path_excluded(Path(full), opts, root):
                    continue
                yield Path(full), False              # 扫目录得到


def read_file_list(spec: str) -> list[str]:
    """
    读一个"文件列表"：每行一个路径，忽略空行与 # 注释，允许行尾注释，
    允许用引号包住含空格的路径。spec 为 - 表示从标准输入读。
    """
    if spec == "-":
        text = sys.stdin.read()
        base = Path.cwd()
    else:
        f = Path(spec).expanduser()
        if not f.is_file():
            raise FileNotFoundError("文件列表不存在：%s" % spec)
        text = f.read_text(encoding="utf-8", errors="replace")
        base = f.parent
    items: list[str] = []
    for raw in text.splitlines():
        line = raw.strip()
        if not line or line.startswith("#"):
            continue
        if " #" in line:
            line = line.split(" #", 1)[0].strip()
        if len(line) >= 2 and line[0] == line[-1] and line[0] in "\"'":
            line = line[1:-1]
        if not line:
            continue
        # 列表里的相对路径优先按"相对列表文件所在目录"解释，找不到再按当前目录
        if not os.path.isabs(line):
            cand = (base / line)
            if not cand.exists():
                cand = Path(line)
            line = str(cand)
        items.append(line)
    return items


def expand_target(raw: str) -> list[str]:
    """
    把一个命令行参数展开成实际路径列表：
    - @file 视为 --files-from 的简写；
    - 含有 * ? [ 且按字面不存在时，用 glob 展开（支持 ** 递归）；
    - 其余原样返回（包括不存在的路径，交给后面报错）。
    """
    if raw.startswith("@") and len(raw) > 1:
        return read_file_list(raw[1:])
    if any(c in raw for c in "*?[") and not os.path.exists(raw):
        hits = sorted(globlib.glob(raw, recursive=True))
        if hits:
            return hits
    return [raw]


def collect_targets(args_paths: list[str], files_from: list[str]) -> tuple[list[Path], list[str]]:
    """
    汇总所有处理目标，返回 (路径列表, 展开时的错误信息)。
    顺序保持用户给的顺序，重复项去掉。
    """
    raws: list[str] = []
    errors: list[str] = []
    for spec in files_from:
        try:
            raws.extend(read_file_list(spec))
        except FileNotFoundError as exc:
            errors.append(str(exc))
    for raw in args_paths:
        try:
            raws.extend(expand_target(raw))
        except FileNotFoundError as exc:
            errors.append(str(exc))
    seen: set[str] = set()
    out: list[Path] = []
    for raw in raws:
        p = Path(raw).expanduser()
        key = str(p)
        if key in seen:
            continue
        seen.add(key)
        out.append(p)
    return out, errors


def path_excluded(path: Path, opts: Options, root: Path | None = None) -> bool:
    """
    --exclude 匹配规则（尽量贴近直觉）：
      --exclude '*/libraries/*'   按通配符匹配完整相对路径
      --exclude 'board/*.h'       匹配任意"路径尾部"，不必写前面的目录
      --exclude vendor            不含 / 也不含通配符时按"目录/文件名"匹配，
                                  等价于 --skip-dir，任意层级都生效
    """
    if not opts.excludes:
        return False
    try:
        rel = str(path.relative_to(Path.cwd()))
    except ValueError:
        rel = str(path)
    rel = rel.replace(os.sep, "/")
    parts = rel.split("/")
    # 待比较的候选：完整相对路径、各层后缀子路径、文件名
    cands = {rel, path.name}
    for i in range(len(parts)):
        cands.add("/".join(parts[i:]))

    for pat in opts.excludes:
        pat_n = pat.replace(os.sep, "/").strip().rstrip("/")
        pat_n = pat_n[2:] if pat_n.startswith("./") else pat_n
        if not pat_n:
            continue
        if "/" not in pat_n and not any(c in pat_n for c in "*?["):
            if pat_n in parts:          # 按名字匹配任意层级的目录/文件
                return True
            continue
        if any(fnmatch.fnmatch(c, pat_n) for c in cands):
            return True
    return False


def should_scan(path: Path, opts: Options, explicit: bool = False) -> tuple[bool, str]:
    """
    是否处理这个文件。explicit=True 表示用户在命令行/文件列表里点了名：
    此时不再受后缀黑名单（.mht/.dat/... ）、--ext 白名单限制——
    点名了就是要处理，只保留"内容层"的二进制拦截。
    """
    if explicit:
        return True, ""
    ext = path.suffix.lower()
    if opts.exts and ext not in opts.exts:
        return False, "后缀不在白名单"
    if ext in BINARY_EXT:
        return False, "二进制后缀"
    if ext in MHT_EXT and not opts.include_mht:
        return False, "MHT 归档（quoted-printable），默认跳过"
    return True, ""


# --------------------------------------------------------------------------
# 转换
# --------------------------------------------------------------------------

class Backup:
    """备份/回退：把原件按相对路径复制到 backup_dir/files/ 下，并记录 manifest。"""

    def __init__(self, backup_dir: Path, base: Path):
        self.dir = backup_dir
        self.base = base
        self.files_dir = backup_dir / "files"
        self.manifest = backup_dir / "manifest.tsv"
        self.records: list[tuple[str, str, str, str]] = []
        try:
            self.dir.mkdir(parents=True, exist_ok=True)
            marker = self.dir / BACKUP_MARKER
            if not marker.exists():
                marker.write_text(BACKUP_MARKER_TEXT, encoding="utf-8")
        except OSError:
            pass

    def save(self, path: Path, encoding: str, raw: bytes) -> None:
        self.files_dir.mkdir(parents=True, exist_ok=True)
        try:
            rel = path.resolve().relative_to(self.base.resolve())
        except ValueError:
            rel = Path(path.name)
        dest = self.files_dir / rel
        dest.parent.mkdir(parents=True, exist_ok=True)
        dest.write_bytes(raw)
        self.records.append((str(rel), encoding, sha256(raw), oct(path.stat().st_mode)))

    def write_manifest(self) -> None:
        if not self.records:
            return
        with self.manifest.open("a", encoding="utf-8") as fh:
            for rel, enc, dig, mode in self.records:
                fh.write("%s\t%s\t%s\t%s\n" % (rel, enc, dig, mode))


def do_convert(path: Path, info: Info, opts: Options, backup: Backup | None) -> None:
    raw = path.read_bytes()
    text = raw.decode(info.encoding)              # type: ignore[arg-type]
    new = text.encode("utf-8")

    # 校验 1：回环还原必须与原件逐字节相同
    if new.decode("utf-8").encode(info.encoding) != raw:   # type: ignore[arg-type]
        raise RuntimeError("回环校验失败")

    # 校验 2：ASCII 骨架（去掉所有 >=0x80 的字节）必须完全一致
    if bytes(b for b in raw if b < 0x80) != bytes(b for b in new if b < 0x80):
        raise RuntimeError("ASCII 骨架发生变化")

    if path.suffix.lower() in MARKUP_EXT and opts.update_html_charset:
        new = rewrite_charset(new, info.encoding)      # type: ignore[arg-type]

    if backup is not None:
        backup.save(path, info.encoding, raw)          # type: ignore[arg-type]
    path.write_bytes(new)
    info.converted = True


def do_revert(backup_dir: Path) -> int:
    manifest = backup_dir / "manifest.tsv"
    if not manifest.exists():
        print("未找到 %s" % manifest, file=sys.stderr)
        return 1
    n = 0
    for line in manifest.read_text(encoding="utf-8").splitlines():
        if not line.strip():
            continue
        rel, enc, dig, mode = line.split("\t")
        src = backup_dir / "files" / rel
        if not src.exists():
            print("⚠ 备份缺失，跳过：%s" % rel, file=sys.stderr)
            continue
        data = src.read_bytes()
        if sha256(data) != dig:
            print("⚠ 备份校验和不符：%s" % rel, file=sys.stderr)
        dest = Path(rel)
        dest.parent.mkdir(parents=True, exist_ok=True)
        shutil.copyfile(src, dest)
        try:
            os.chmod(dest, int(mode, 8))
        except OSError:
            pass
        n += 1
    print("已回退 %d 个文件（源编码按 manifest 记录：%s）" % (n, manifest))
    return 0


# --------------------------------------------------------------------------
# 主流程
# --------------------------------------------------------------------------

KIND_LABEL = {
    "chinese": "中文乱码",
    "western": "西文假乱码",
    "ambiguous": "待确认",
    "mojibake-suspect": "疑似双重编码",
    "utf-16": "UTF-16",
    "unknown": "未知编码",
    "binary": "二进制",
    "skipped": "跳过",
    "empty": "空文件",
    "ascii": "纯 ASCII",
    "utf-8": "已是 UTF-8",
}

ACTION_ORDER = {"chinese": 0, "ambiguous": 1, "western": 2, "mojibake-suspect": 3,
                "utf-16": 4, "unknown": 5}


def rel_to_cwd(p: str) -> str:
    """把脚本路径显示成相对当前目录（在 PATH 里调用时更好看）。"""
    try:
        return os.path.relpath(p, Path.cwd())
    except ValueError:
        return p


def write_json_report(path_arg: str, opts: Options, roots: list[Path],
                      counts: "collections.Counter", results: list[Info],
                      summary: dict[str, int]) -> None:
    """输出机器可读报告，便于 CI / 编辑器插件消费。--json - 表示写到标准输出。"""
    import json

    payload = {
        "tool": "convert_to_utf8",
        "version": VERSION,
        "realdo": opts.realdo,
        "western": opts.western,
        "roots": [str(r) for r in roots],
        "cwd": str(Path.cwd()),
        "summary": dict(summary),
        "counts": dict(counts),
        "scanned": sum(counts.values()),
        "converted": sum(1 for i in results if i.converted),
        "files": [
            {
                "path": i.rel,
                "kind": i.kind,
                "kind_label": KIND_LABEL.get(i.kind, i.kind),
                "encoding": i.encoding,
                "size": i.size,
                "cjk": i.cjk,
                "max_run": i.run,
                "nonascii": i.nonascii,
                "explicit": i.explicit,
                "in_string_literal": i.in_literal,
                "action": i.action,
                "converted": i.converted,
                "note": i.note,
            }
            for i in results
        ],
    }
    text = json.dumps(payload, ensure_ascii=False, indent=2) + "\n"
    if path_arg == "-":
        # JSON 永远走真正的 stdout（--json - 时人看的汇总已改道 stderr）
        print(text, end="", file=sys.stdout)
        return
    out = Path(path_arg)
    if out.parent and not out.parent.exists():
        out.parent.mkdir(parents=True, exist_ok=True)
    out.write_text(text, encoding="utf-8")
    print("JSON 报告：%s" % out)


def run(argv: list[str]) -> int:
    ap = argparse.ArgumentParser(
        prog="convert_to_utf8.py",
        description="把含中文乱码（GBK/GB2312/Big5 等非 UTF-8）的文本文件批量转成 UTF-8。\n"
                    "不带任何参数运行时只打印本帮助，不会扫描或修改任何文件。",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="示例：\n"
               "  convert_to_utf8.py a.c b.h                  # 只处理点名的文件\n"
               "  convert_to_utf8.py --files-from list.txt -r # 按清单处理\n"
               "  convert_to_utf8.py . --exclude '*/lib/*'    # 扫目录并排除\n"
               "  convert_to_utf8.py . --list                 # 只列出会被转换的文件\n"
               "  convert_to_utf8.py src                      # 只看报告（默认 dry-run）\n"
               "  convert_to_utf8.py src --realdo            # 真正转换（自动备份）\n"
               "  convert_to_utf8.py src --western --realdo  # 连 CP1252 假乱码一起处理\n"
               "  convert_to_utf8.py . --check               # 自检，有非 UTF-8 中文则退出码 1\n"
               "  convert_to_utf8.py --revert .utf8_backup   # 回退\n"
               "  convert_to_utf8.py --self-test             # 自测\n"
               "\n"
               "退出码：\n"
               "  0  正常（含 dry-run 有发现、已转换成功）\n"
               "  1  --check 失败：仍存在非 UTF-8 文件\n"
               "  2  用法错误：未给路径、路径不存在、参数冲突\n"
               "  3  转换过程中有文件失败\n",
    )
    ap.add_argument("paths", nargs="*", default=[], metavar="路径",
                    help="要处理的目录或文件，可混着写多个；点名指定的文件不受后缀过滤限制；"
                         "支持通配符（内部展开）与 @清单文件；扫描当前目录请显式写 .")
    mode = ap.add_mutually_exclusive_group()
    mode.add_argument("-r", "--realdo", action="store_true",
                      help="真正执行转换，会写文件（默认只报告，即 dry-run）")
    mode.add_argument("-n", "--dry-run", action="store_true",
                      help="只报告不写文件（默认行为，写出来是为了自文档化）")
    ap.add_argument("-w", "--western", action="store_true",
                    help="同时转换西文假乱码（CP1252 的 ’ “ ” – ° µ 等）")
    ap.add_argument("--ambiguous", choices=["skip", "chinese", "western"], default="skip",
                    help="孤立汉字文件如何处理，默认 skip（只报告）")
    ap.add_argument("--enc", action="append", default=[], metavar="ENC",
                    help="强制指定源编码，可重复（如 --enc gb18030 --enc big5）")
    ap.add_argument("--min-run", type=int, default=2,
                    help="判定真中文的最短连续中文长度，默认 2")
    ap.add_argument("--ext", action="append", default=[], metavar=".c",
                    help="只处理这些后缀，可重复；不指定则按内置二进制后缀排除")
    ap.add_argument("--skip-dir", action="append", default=[], metavar="DIR",
                    help="额外跳过的目录名")
    ap.add_argument("--include-mht", action="store_true", help="连 .mht/.mhtml 一起处理")
    ap.add_argument("--no-html-charset", action="store_true",
                    help="转换 HTML 时不改 charset 声明")
    ap.add_argument("--strip-bom", action="store_true", help="去掉 UTF-8 BOM")
    ap.add_argument("--max-size", type=int, default=32 * 1024 * 1024,
                    help="单文件最大字节数，默认 32MB")
    ap.add_argument("--backup-dir", default=".utf8_backup", metavar="DIR",
                    help="备份目录，默认 .utf8_backup")
    ap.add_argument("--no-backup", action="store_true", help="不备份（不推荐）")
    ap.add_argument("--strict", action="store_true",
                    help="非 ASCII 出现在字符串字面量里时跳过该文件")
    ap.add_argument("--check", action="store_true",
                    help="自检模式：发现非 UTF-8 中文文件则退出码 1")
    ap.add_argument("--path-width", type=int, default=80, metavar="N",
                    help="报告中文件路径列的最大显示宽度，默认 80（超出用 … 省略中间）")
    ap.add_argument("--files-from", action="append", default=[], metavar="FILE",
                    help="从文件读待处理路径清单（每行一个，# 注释，- 表示标准输入）；"
                         "也可在命令行直接写 @文件名")
    ap.add_argument("--exclude", action="append", default=[], metavar="GLOB",
                    help="扫目录时排除匹配的路径，可重复（如 '*/libraries/*'、'board/*.h'）")
    ap.add_argument("--json", metavar="FILE", help="把结构化报告写到 FILE（- 表示标准输出）")
    ap.add_argument("--list", action="store_true",
                    help="只打印将被转换的文件路径（每行一个，便于管道/生成清单）")
    ap.add_argument("-q", "--quiet", action="store_true",
                    help="只打印汇总行，不打印文件明细表")
    ap.add_argument("-v", "--verbose", action="store_true", help="打印每个文件的处理细节")
    ap.add_argument("--revert", metavar="BACKUP_DIR", help="从备份目录回退")
    ap.add_argument("--self-test", action="store_true", help="运行内置自测")
    ap.add_argument("--version", action="version", version="convert_to_utf8 %s" % VERSION)

    # 完全不带参数：打印帮助，什么都不做（避免误扫当前目录）
    if not argv:
        ap.print_help()
        print("\n提示：未指定路径，未做任何操作。要扫描当前目录请显式运行：\n"
              "  python3 %s ." % ap.prog)
        return 2

    args = ap.parse_args(argv)

    if args.self_test:
        return self_test()
    if args.revert:
        return do_revert(Path(args.revert))

    # 只给了开关却没给路径：属于用法错误，不做隐式扫描
    if not args.paths and not args.files_from:
        ap.error("请指定要处理的目录或文件（或用 --files-from/@清单；扫描当前目录请显式写 .）")

    opts = Options(
        realdo=args.realdo,
        western=args.western,
        ambiguous=args.ambiguous,
        encodings=tuple(args.enc),
        min_run=max(1, args.min_run),
        exts={e.lower() if e.startswith(".") else "." + e.lower() for e in args.ext},
        excludes=tuple(args.exclude),
        skip_dirs=SKIP_DIRS | set(args.skip_dir),
        include_mht=args.include_mht,
        update_html_charset=not args.no_html_charset,
        strip_bom=args.strip_bom,
        max_size=args.max_size,
        backup_dir=None if args.no_backup else Path(args.backup_dir),
        strict=args.strict,
        check=args.check,
        path_width=max(24, args.path_width),
        quiet=args.quiet,
        list_only=args.list,
        json_path=args.json,
        verbose=args.verbose,
    )

    # --json - / --list 时 stdout 必须保持纯净（可管道），人类可读输出改走 stderr
    stream = sys.stderr if (args.json == "-" or args.list) else sys.stdout

    def emit(*parts, **kw) -> None:
        print(*parts, file=stream, **kw)

    roots, target_errors = collect_targets(args.paths, args.files_from)
    for err in target_errors:
        print("错误：%s" % err, file=sys.stderr)
    missing = [str(p) for p in roots if not p.exists()]
    if missing:
        for m in missing:
            print("路径不存在：%s" % m, file=sys.stderr)
        return 2
    if not roots:
        print("没有可处理的目标（清单为空？）", file=sys.stderr)
        return 2

    base = Path.cwd()
    if opts.backup_dir:
        opts.exclude_dirs = (opts.backup_dir,)
    backup = Backup(opts.backup_dir, base) if (opts.realdo and opts.backup_dir) else None

    results: list[Info] = []
    counts: collections.Counter = collections.Counter()
    for path, explicit in iter_files(roots, opts):
        ok, why = should_scan(path, opts, explicit)
        if not ok:
            if opts.verbose:
                print("跳过 %s（%s）" % (path, why), file=sys.stderr)
            continue
        try:
            size = path.stat().st_size
        except OSError:
            continue
        if size > opts.max_size:
            print("跳过 %s（超过 --max-size）" % path, file=sys.stderr)
            continue
        data = path.read_bytes()
        if looks_binary(data):
            if explicit:
                # 点名了但内容确实是二进制：明确告知，而不是静默跳过
                print("跳过 %s（内容像二进制，未转换）" % path, file=sys.stderr)
            continue

        info = classify(data, opts)
        info.explicit = explicit
        counts[info.kind] += 1
        info.path = path
        try:
            info.rel = str(path.resolve().relative_to(base))
        except ValueError:
            info.rel = str(path)

        # 决定动作
        want = False
        if info.kind == "chinese":
            want = True
        elif info.kind == "western":
            want = opts.western
            info.action = "转换" if want else "跳过（需 --western）"
        elif info.kind == "ambiguous":
            if opts.ambiguous == "chinese":
                info.encoding = "gb18030"; want = True
            elif opts.ambiguous == "western":
                want = bool(opts.western); info.encoding = "cp1252"
                info.action = "转换" if want else "跳过（需 --western）"
            else:
                info.action = "跳过（需 --ambiguous 指定）"
        elif info.kind == "utf-8" and opts.strip_bom and data.startswith(UTF8_BOM):
            want = True
            info.action = "去 BOM"
        elif info.kind in ("utf-8", "ascii"):
            info.action = "无需处理"
        elif info.kind == "mojibake-suspect":
            info.action = "跳过（需人工确认）"
        else:
            info.action = "跳过"

        # 字面量告警：只对将要转换的文件做（避免为不动的文件白跑一遍全文件扫描）
        if want and not info.in_literal and path.suffix.lower() in CODE_EXT:
            info.in_literal = scan_literals(data.decode(info.encoding, errors="replace"))  # type: ignore[arg-type]

        if want and opts.strict and info.in_literal:
            want = False
            info.action = "跳过（--strict：字面量含非 ASCII）"

        if want:
            if opts.realdo:
                try:
                    if opts.strip_bom and info.kind == "utf-8":
                        raw = data
                        if backup:
                            backup.save(path, "utf-8-bom", raw)
                        path.write_bytes(raw[len(UTF8_BOM):])
                        info.converted = True
                        info.action = "已去 BOM"
                    else:
                        do_convert(path, info, opts, backup)
                        info.action = "已转换"
                except Exception as exc:               # noqa: BLE001
                    info.action = "失败"
                    info.note = (info.note + " | " if info.note else "") + str(exc)
            else:
                if info.kind in ("chinese", "western", "ambiguous"):
                    info.action = "将转换（dry-run）"

        if info.kind not in ("ascii", "utf-8", "empty") or opts.verbose:
            results.append(info)

    # ---------------- 报告 ----------------
    results.sort(key=lambda i: (ACTION_ORDER.get(i.kind, 9), i.rel))
    interesting = [i for i in results if i.kind not in ("ascii", "utf-8")]

    if opts.list_only:
        for i in interesting:
            if i.kind in ("chinese", "western", "ambiguous") or i.converted:
                print(i.rel, file=sys.stdout)

    if interesting and not opts.quiet and not opts.list_only:
        path_cap = opts.path_width
        w_path = max(disp_width("文件") + 2,
                     max(min(disp_width(i.rel), path_cap) for i in interesting) + 2)
        w_kind = max(disp_width("类别") + 2,
                     max(disp_width(KIND_LABEL.get(i.kind, i.kind)) for i in interesting) + 2)
        header = (pad("文件", w_path) + pad("类别", w_kind)
                  + pad("编码", 12) + pad("汉字", 6) + pad("连续", 6)
                  + pad("非ASCII", 9) + "动作 / 备注")
        emit(header)
        emit("-" * min(150, disp_width(header)))
        for i in interesting:
            line = (pad(elide(i.rel, path_cap), w_path)
                    + pad(KIND_LABEL.get(i.kind, i.kind), w_kind)
                    + pad(i.encoding or "-", 12)
                    + pad(str(i.cjk), 6)
                    + pad(str(i.run), 6)
                    + pad(str(i.nonascii), 9)
                    + i.action)
            note = i.note
            if i.in_literal and opts.warn_literals:
                note = (note + " | " if note else "") + "⚠ 字符串字面量含非 ASCII %d 处（会改变运行期字节）" % i.in_literal
            if note:
                line += "  —  " + note
            emit(line)
        emit()

    summary = {
        "中文乱码": counts["chinese"],
        "西文假乱码": counts["western"],
        "待确认": counts["ambiguous"],
        "疑似双重编码": counts["mojibake-suspect"],
        "其他非 UTF-8": counts["utf-16"] + counts["unknown"],
    }
    tail = ["空文件 %d" % counts["empty"]] if counts["empty"] else []
    parts = ["%s %d" % (k, v) for k, v in summary.items() if v] + tail
    emit("扫描结果：" + ("，".join(parts) if parts else "没有非 UTF-8 文件"))
    if opts.realdo:
        done = [i for i in results if i.converted]
        emit("已转换 %d 个文件" % len(done))
        if backup and backup.records:
            backup.write_manifest()
            emit("备份目录：%s（回退：python3 %s --revert %s）"
                  % (backup.dir, rel_to_cwd(sys.argv[0]), backup.dir))
        skipped_w = [i for i in results if i.kind == "western" and not i.converted]
        if skipped_w:
            emit("提示：有 %d 个西文假乱码文件未处理，加 --western 可一并转换" % len(skipped_w))
    else:
        pending = counts["chinese"] + (counts["western"] if opts.western else 0)
        if pending:
            emit("dry-run，未写任何文件。加 --realdo 执行转换。")
        elif counts["western"] and not opts.western:
            emit("提示：发现 %d 个西文假乱码文件（英文里的 ’ “ ” – ° µ），加 --western 可一并转换。"
                  % counts["western"])

    if opts.json_path:
        write_json_report(opts.json_path, opts, roots, counts, results, summary)

    if opts.check and (counts["chinese"] or (opts.western and counts["western"])):
        print("✗ check 失败：仍存在非 UTF-8 文件", file=sys.stderr)
        return 1
    if any(i.action == "失败" for i in results):
        return 3
    return 0


# --------------------------------------------------------------------------
# 自测
# --------------------------------------------------------------------------

def self_test() -> int:
    """在临时目录里造 GBK / CP1252 / UTF-8 / 二进制样例，跑完整流程并断言。"""
    me = os.path.abspath(__file__)
    failures: list[str] = []

    def check(name: str, cond: bool, detail: str = "") -> None:
        print("  %s %s%s" % ("PASS" if cond else "FAIL", name, ("  " + detail) if detail and not cond else ""))
        if not cond:
            failures.append(name)

    with tempfile.TemporaryDirectory() as tmp:
        root = Path(tmp) / "proj"
        (root / "board").mkdir(parents=True)
        (root / "vendor").mkdir(parents=True)
        (root / "build").mkdir(parents=True)

        gbk_text = "/*\r\n * 清空计数器，开始计数\r\n * 延时函数：微秒延时\r\n */\r\nint a = 1;\r\n"
        gbk_lit = '/* 中文注释 */\r\nconst char *s = "串口输出：系统时钟";\r\n'
        utf8_text = "/* 已经是 UTF-8 的中文 */\nint b = 2;\n"
        west_text = "/* the peripheral\u2019s registers, N\u00b0 0, ~83\u00b5s */\nint c = 3;\n"

        (root / "board" / "board.c").write_bytes(gbk_text.encode("gbk"))
        (root / "board" / "lit.c").write_bytes(gbk_lit.encode("gbk"))
        (root / "board" / "utf8.c").write_bytes(utf8_text.encode("utf-8"))
        (root / "vendor" / "stm32f4xx.h").write_bytes(west_text.encode("cp1252"))
        (root / "build" / "gen.c").write_bytes(gbk_text.encode("gbk"))       # 应被跳过
        (root / "bin.dat").write_bytes(b"\x00\x01\xff\xfe" + gbk_text.encode("gbk"))

        def run_cli(*extra: str) -> tuple[int, str]:
            """在临时目录里跑本脚本自己（备份也落在临时目录，不污染当前工作区）。"""
            p = subprocess.run(
                [sys.executable, me, str(root), *extra],
                capture_output=True, text=True, cwd=tmp,
            )
            return p.returncode, p.stdout + p.stderr

        def run_raw(args: list[str], cwd: str) -> tuple[int, str]:
            """不带隐式路径地调用脚本，用于验证"缺省参数"的行为。"""
            p = subprocess.run(
                [sys.executable, me, *args],
                capture_output=True, text=True, cwd=cwd,
            )
            return p.returncode, p.stdout + p.stderr

        def run_split(args: list[str], cwd: str) -> tuple[int, str, str]:
            """分别拿到 stdout 与 stderr，用于验证 --json - 的纯净输出。"""
            p = subprocess.run(
                [sys.executable, me, *args],
                capture_output=True, text=True, cwd=cwd,
            )
            return p.returncode, p.stdout, p.stderr

        # 0) 缺省参数：只打印帮助/用法，绝不扫描或修改文件
        gbk_before = (root / "board" / "board.c").read_bytes()
        rc, out = run_raw([], cwd=str(root))          # 故意在含乱码文件的目录里裸跑
        check("无参数退出码 2", rc == 2, "rc=%d\n%s" % (rc, out))
        check("无参数打印用法", "usage:" in out, out)
        check("无参数给出提示", "未指定路径" in out, out)
        check("无参数不扫描", "扫描结果" not in out, out)
        check("无参数不改文件", (root / "board" / "board.c").read_bytes() == gbk_before)

        # 0b) 只给开关不给路径 -> 同样是用法错误，不隐式扫描当前目录
        rc, out = run_raw(["--western", "--realdo"], cwd=str(root))
        check("只给开关不给路径退出码 2", rc == 2, "rc=%d\n%s" % (rc, out))
        check("只给开关不给路径不改文件", (root / "board" / "board.c").read_bytes() == gbk_before)

        # 0c) --realdo 与 --dry-run 互斥
        rc, out = run_raw([str(root), "--realdo", "--dry-run"], cwd=tmp)
        check("--realdo/--dry-run 互斥退出码 2", rc == 2, out)

        # 1) dry-run 只报告
        rc, out = run_cli()
        check("dry-run 退出码 0", rc == 0, out)
        check("dry-run 不写文件", (root / "board" / "board.c").read_bytes() == gbk_text.encode("gbk"))
        check("识别出中文乱码 2 个", out.count("中文乱码") >= 2, out)
        check("识别出西文假乱码", "西文假乱码" in out, out)

        # 1b) --dry-run 显式写法等价
        rc, out = run_cli("--dry-run")
        check("--dry-run 显式写法退出码 0", rc == 0, out)
        check("--dry-run 仍不写文件", (root / "board" / "board.c").read_bytes() == gbk_before)

        # 1c) --json - 输出纯 JSON（stdout 可管道给 jq）；-q 不打印明细表
        import json as _json
        rc, jout, jerr = run_split([str(root), "--json", "-", "-q"], tmp)
        try:
            payload = _json.loads(jout)
            check("--json - 是合法 JSON", True)
        except Exception as exc:                       # noqa: BLE001
            payload = {}
            check("--json - 是合法 JSON", False, "%s\nstdout=%r" % (exc, jout[:200]))
        check("--json - 的 stdout 无杂音", jout.lstrip().startswith("{") and jout.rstrip().endswith("}"),
              jout[:200])
        check("--json - 汇总走 stderr", "扫描结果" in jerr, jerr[:200])
        check("--json 汇总含中文乱码", payload.get("summary", {}).get("中文乱码", 0) >= 2, jout[:400])
        check("--json 统计到扫描文件数", payload.get("scanned", 0) >= 4, jout[:200])
        check("--json 记录文件明细", any(f["kind"] == "chinese" for f in payload.get("files", [])), jout[:200])
        check("-q 不打印明细表头", "动作 / 备注" not in jerr, jerr[:300])

        # 1d) --json 写文件
        rc, out = run_cli("--json", "rep.json", "-q")
        check("--json 写文件成功", (Path(tmp) / "rep.json").exists(), out)

        # 2) realdo
        rc, out = run_cli("--realdo")
        check("realdo 退出码 0", rc == 0, out)
        board = (root / "board" / "board.c").read_bytes()
        check("board.c 变成合法 UTF-8", try_decode(board, "utf-8") is not None)
        check("board.c 中文正确", "清空计数器" in board.decode("utf-8"))
        check("CRLF 保留", board.count(b"\r\n") == gbk_text.count("\r\n"),
              "%d vs %d" % (board.count(b"\r\n"), gbk_text.count("\r\n")))
        check("ASCII 骨架不变", bytes(b for b in board if b < 0x80)
              == bytes(b for b in gbk_text.encode("gbk") if b < 0x80))
        check("build/ 被跳过", (root / "build" / "gen.c").read_bytes() == gbk_text.encode("gbk"))
        check("二进制被跳过", (root / "bin.dat").read_bytes().startswith(b"\x00\x01"))
        check("UTF-8 文件未改动", (root / "board" / "utf8.c").read_bytes() == utf8_text.encode("utf-8"))
        check("西文文件未转换（无 --western）",
              (root / "vendor" / "stm32f4xx.h").read_bytes() == west_text.encode("cp1252"))
        check("字面量告警", "字符串字面量含非 ASCII" in out, out)

        # 3) --western
        rc, out = run_cli("--western", "--realdo")
        vend = (root / "vendor" / "stm32f4xx.h").read_bytes().decode("utf-8")
        check("--western 转换 CP1252", "peripheral\u2019s" in vend and "\u00b0" in vend, vend)

        # 3b) 自定义 --backup-dir 落在被扫描的树里时，备份副本不能被当成待转换文件
        (root / "board" / "board.c").write_bytes(gbk_text.encode("gbk"))   # 复原成乱码
        rc, out = run_raw([str(root), "--realdo", "--backup-dir", str(root / ".bk")], tmp)
        check("备份目录在树内时 realdo 成功", rc == 0, out)
        check("备份目录带自识别标记", (root / ".bk" / ".utf8_backup_marker").exists())
        rc, out = run_raw([str(root), "-q"], tmp)        # 故意不带 --backup-dir
        check("备份副本不被当成待转换文件", "中文乱码" not in out and "西文假乱码" not in out, out)

        # 3c) 选择能力：只处理点名的文件 / 清单 / 通配符 / 排除
        gbk_body = "/* 清空计数器，开始计数 */\r\nint a = 1;\r\n"

        def make_tree(name: str) -> Path:
            root2 = Path(tmp) / name
            for d in ("board", "app", "vendor"):
                (root2 / d).mkdir(parents=True, exist_ok=True)
            for rel in ("board/board.c", "board/board.h", "app/main.c", "vendor/lib.c"):
                (root2 / rel).write_bytes(gbk_body.encode("gbk"))
            (root2 / "board" / "notes.mht").write_bytes(gbk_body.encode("gbk"))
            (root2 / "board" / "t.bin").write_bytes(b"\x00\x01" + gbk_body.encode("gbk"))
            return root2

        sel = make_tree("sel")        # 用于点名转换
        selb = make_tree("selb")      # 用于只读列举（保持乱码原状）
        selc = make_tree("selc")      # 用于"扫目录"的真实转换

        # 点名两个文件：只有这两个被转，其余原地不动
        rc, out = run_raw([str(sel / "board/board.c"), str(sel / "app/main.c"), "--realdo", "-q"], tmp)
        check("点名两个文件退出码 0", rc == 0, out)
        check("点名文件已转换", try_decode((sel / "board" / "board.c").read_bytes(), "utf-8") is not None, out)
        check("同名目录里未点名的文件不动",
              (sel / "board" / "board.h").read_bytes() == gbk_body.encode("gbk"))
        check("未点名的目录不动",
              (sel / "vendor" / "lib.c").read_bytes() == gbk_body.encode("gbk"))

        # 点名含后缀黑名单的文件（.mht）：点名了就该处理
        rc, out = run_raw([str(sel / "board" / "notes.mht"), "--realdo", "-q"], tmp)
        check("点名 .mht 会被处理",
              try_decode((sel / "board" / "notes.mht").read_bytes(), "utf-8") is not None, out)
        # 而扫目录时 .mht 仍按默认跳过（用独立夹具，避免把 selb 转掉影响后面的只读断言）
        rc, out = run_raw([str(selc), "--realdo", "-q"], tmp)
        check("扫目录时 .mht 仍跳过",
              (selc / "board" / "notes.mht").read_bytes() == gbk_body.encode("gbk"), out)
        check("扫目录时普通文件照常转换",
              try_decode((selc / "board" / "board.c").read_bytes(), "utf-8") is not None, out)

        # 点名内容为二进制的文件：明确告知，不改动
        bin_before = (sel / "board" / "t.bin").read_bytes()
        rc, out = run_raw([str(sel / "board" / "t.bin"), "--realdo"], tmp)
        check("点名二进制被拦下且不改动",
              (sel / "board" / "t.bin").read_bytes() == bin_before and "二进制" in out, out)

        # 点名文件不受 --ext 白名单限制
        rc, jout, _ = run_split([str(selb / "board/board.c"), "--ext", ".h", "--list"], tmp)
        check("点名文件不受 --ext 白名单限制", "board.c" in jout, jout)

        # --list：stdout 只有路径
        rc, jout, jerr = run_split([str(selb), "--list"], tmp)
        listed = [l for l in jout.splitlines() if l.strip()]
        check("--list 只输出待转换路径", len(listed) == 4 and all(not l.startswith("扫描") for l in listed), jout)
        check("--list 的人类汇总走 stderr", "扫描结果" in jerr, jerr)

        # --exclude 三种写法
        rc, jout, _ = run_split([str(selb), "--exclude", "vendor", "--list"], tmp)
        check("--exclude 按目录名排除", "vendor" not in jout and "board/board.h" in jout, jout)
        rc, jout, _ = run_split([str(selb), "--exclude", "board/*.h", "--list"], tmp)
        check("--exclude 按路径尾部排除", "board.h" not in jout and "vendor/lib.c" in jout, jout)
        rc, jout, _ = run_split([str(selb), "--exclude", "*/vendor/*", "--list"], tmp)
        check("--exclude 通配符排除", "vendor" not in jout, jout)

        # --files-from：注释/空行/相对清单文件的路径；@ 简写等价
        lst = selb / "list.txt"
        lst.write_text("# 只转这两个\nboard/board.h\n\nvendor/lib.c   # 备注\n", encoding="utf-8")
        rc, j1, _ = run_split(["--files-from", str(lst), "--list"], tmp)
        rc2, j2, _ = run_split(["@" + str(lst), "--list"], tmp)
        listed1 = [l for l in j1.splitlines() if l.strip()]
        check("--files-from 解析注释与空行",
              len(listed1) == 2
              and any(l.endswith("board/board.h") for l in listed1)
              and any(l.endswith("vendor/lib.c") for l in listed1), repr(j1))
        check("@清单简写等价", j1 == j2, j1 + "|" + j2)

        # 通配符（含 ** 递归）
        rc, jout, _ = run_split([str(selb / "*" / "*.c"), "--list"], tmp)
        check("通配符自动展开", "app/main.c" in jout and "vendor/lib.c" in jout, jout)
        rc, jout, _ = run_split([str(selb) + "/**/*.h", "--list"], tmp)
        check("通配符 ** 递归", "board/board.h" in jout, jout)

        # JSON 报告里标出"点名指定"
        rc, jout, _ = run_split([str(selb / "app/main.c"), "--json", "-", "-q"], tmp)
        try:
            payload2 = _json.loads(jout)
            check("JSON 标出 explicit",
                  any(f["explicit"] for f in payload2["files"]), jout[:200])
        except Exception as exc:                       # noqa: BLE001
            check("JSON 标出 explicit", False, "%s %s" % (exc, jout[:200]))

        # 4) check 模式
        rc, _ = run_cli("--check")
        check("check 通过（已无乱码）", rc == 0)

        # 5) revert：备份落在临时目录里
        bdir = Path(tmp) / ".utf8_backup"
        if bdir.exists():
            p = subprocess.run([sys.executable, me, "--revert", str(bdir)],
                               capture_output=True, text=True, cwd=tmp)
            check("revert 退出码 0", p.returncode == 0, p.stdout + p.stderr)
            check("revert 后 board.c 恢复 GBK",
                  (root / "board" / "board.c").read_bytes() == gbk_text.encode("gbk"))
        else:
            check("备份目录已生成", False, str(bdir))

    # 6) 分类启发式单测
    solo = Options()
    i1 = classify("/* 清空计数器 */".encode("gbk"), solo)
    i2 = classify("/* peripheral\u2019s */".encode("cp1252"), solo)
    i3 = classify("/* 值 */".encode("gbk"), solo)
    i4 = classify("/* 83\u00b5s */".encode("cp1252"), solo)
    check("中文文件判定 chinese", i1.kind == "chinese", i1.kind)
    check("英文弯引号判定 western", i2.kind == "western", i2.kind)
    check("孤立汉字不误判为中文", i3.kind != "chinese", i3.kind)
    check("µ 不误判为中文", i4.kind == "western", i4.kind)
    check("已 UTF-8 文件判定 utf-8", classify("中文".encode("utf-8"), solo).kind == "utf-8")

    # 7) 被优化过的热点函数：结果必须与语义一致（性能改动不能改行为）
    check("连续长度统计=5", i1.run == 5, str(i1.run))
    check("汉字个数统计=5", i1.cjk == 5, str(i1.cjk))
    check("伪汉字连续长度=1", i2.run == 1, str(i2.run))
    check("汉字+中文标点算连续", classify("/* 值， */".encode("gbk"), solo).kind == "chinese")
    check("count_nonascii 正确", count_nonascii(b"a\xff\xfe") == 2)
    check("纯 ASCII 判为非二进制", looks_binary(b"int a = 1;\n") is False)
    check("含 NUL 判为二进制", looks_binary(b"abc\x00def") is True)
    # 8) 双重编码检测：不能把"提到乱码特征"的正常文件误报
    me_bytes = Path(me).read_bytes()
    check("本脚本自身不被误报为双重编码", classify(me_bytes, solo).kind == "utf-8",
          classify(me_bytes, solo).kind)
    moji = "是中文测试文件内容示例".encode("utf-8").decode("latin-1")
    strong_sample = "\u9500\u65a4\u62f7" * 3
    check("连片强特征被抓到",
          classify(("x" * 10 + strong_sample + "y" * 10).encode("utf-8"), solo).kind == "mojibake-suspect",
          classify(("x" * 10 + strong_sample + "y" * 10).encode("utf-8"), solo).kind)
    check("构造的双重编码文件被抓到", classify(moji.encode("utf-8"), solo).kind == "mojibake-suspect",
          classify(moji.encode("utf-8"), solo).kind)
    check("正常中文不会误报", classify("这是正常的中文注释".encode("utf-8"), solo).kind == "utf-8")
    check("正常西文不会误报", classify("caf\u00e9 na\u00efve r\u00e9sum\u00e9".encode("utf-8"), solo).kind == "utf-8")
    proper = "party\u2019s \u201cquoted\u201d text \u2013 N\u00b0 0 \u00a9 2024 \u2014 all rights"
    check("已正确转好的西文排版字符不误报",
          classify(proper.encode("utf-8"), solo).kind == "utf-8",
          classify(proper.encode("utf-8"), solo).kind)

    check("西文可读性判断正确",
          western_plausible("N\u00b0 0, 83\u00b5s") is True
          and western_plausible("\u6e05\u7a7a") is False)

    print()
    if failures:
        print("自测失败 %d 项：%s" % (len(failures), ", ".join(failures)))
        return 1
    print("自测全部通过 ✓")
    return 0


if __name__ == "__main__":
    try:
        sys.exit(run(sys.argv[1:]))
    except KeyboardInterrupt:
        sys.exit(130)
