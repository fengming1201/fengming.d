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

  扫目录时默认跳过"没有后缀"的文件（Makefile、Kconfig、README、各种无后缀测试夹具）：
  这类文件量大而后缀给不出任何信号，收益小于噪音；要处理它们点名叫上即可。
  同样整类跳过的还有翻译与测试夹具后缀（.po/.proto/.options/.expected/.input）。

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

  # 8) 兜底一：任何候选编码都解不出的"未知编码"文件，强制按 latin-1 逐字节保真转
  python3 tools/convert_to_utf8.py . --unknown --realdo

  # 9) 兜底二：把"疑似双重编码"的乱码反解回原文（ä½ å¥½ -> 你好）
  python3 tools/convert_to_utf8.py . --multi --realdo

退出码：0 正常（含 dry-run 有发现） / 1 --check 失败 / 2 用法错误（未给路径、
路径不存在、参数冲突） / 3 转换过程中有文件失败。

安全性：只有显式加 --realdo 才会写文件，默认 dry-run（也可显式写 --dry-run）；
不带路径时只打印帮助，绝不隐式扫描当前目录；写文件前先备份原件；转换后校验
「utf-8 解码结果再按源编码编码回去 == 原始字节」（无损、可回退），单字节编码
另加一条「非 ASCII 字节滤掉后的 ASCII 骨架逐字节不变」。注意 GBK/Big5 这类双字节
编码的尾字节可能落在 ASCII 区（"–" = A8 43），ASCII 骨架本来就会变，所以那条
不对它们生效，双字节编码完全靠回环无损这条兜底。
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

#: 固件/镜像/裸视频/签名/位图等"纯二进制"后缀：连点名指定的文件也不转换（见 should_scan）。
#: 为什么单独拎出来：这类文件最容易骗过"内容层"的二进制拦截——例如全 0xFF 的空白
#: flash 镜像既没有 NUL 也没有控制字符，looks_binary() 判不出来，一旦被当成 cp1252
#: 文本"转换"，1MiB 会变成 2MiB，镜像就永久损坏了。所以这里按后缀硬拦。
HARD_BINARY_EXT = {
    ".img", ".jffs2", ".jffs", ".dtb",
    ".yuv",                  # 裸 YUV 视频帧（分辨率×1.5 字节，纯像素数据）
    ".sign",                 # 固件/模块签名块（随包一起烧写，改一个字节就验不过）
    ".ppm",                  # Netpbm 位图（P6 裸像素；仓库里唯一一个就是二进制）
    ".pgm", ".pbm", ".pnm",  # Netpbm 家族其余三个：同样是"裸像素/裸位平面"
}

#: 明确的二进制后缀（不读内容直接跳过）
BINARY_EXT = {
    ".bmp", ".png", ".jpg", ".jpeg", ".gif", ".ico", ".tif", ".tiff", ".webp",
    ".pdf", ".chm", ".zip", ".rar", ".7z", ".gz", ".bz2", ".xz", ".tar",
    ".exe", ".dll", ".so", ".dylib", ".a", ".lib", ".o", ".obj", ".bin",
    ".hex", ".elf", ".axf", ".map", ".pyc", ".class", ".jar", ".db", ".sqlite",
    ".xls", ".xlsx", ".doc", ".docx", ".ppt", ".pptx", ".mp3", ".wav", ".mp4",
    ".ttf", ".otf", ".woff", ".woff2", ".eot", ".psd", ".ai", ".lib", ".uvguix",
} | HARD_BINARY_EXT

#: 扫目录时整类跳过的"文本类"后缀：它们不是二进制，但也不该被本工具动 ——
#: 要么是翻译目录，要么是给测试程序逐字节比对的夹具（内容是"原始字节"而非给人读的
#: 文本），而且这类文件各国语言混排，极易被误判成"疑似双重编码"。
#: 与二进制名单同样是软跳过：点名叫上仍然会处理。
SKIP_TEXT_EXT = {
    ".po",        # gettext 翻译目录
    ".proto",     # protobuf 定义 / Plan9 mkfile 模板
    ".options",   # protobuf 选项、ossfuzz 配置
    ".expected",  # 测试期望输出夹具
    ".input",     # uclibc 等测试夹具（内容常为 ASCII/ISO-8859 原文）
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

#: 单字节编码：只有这些编码下"ASCII 骨架逐字节不变"才是个成立的不变量（见 do_convert）。
#: 双字节编码（gb18030/big5/utf-16…）的尾字节可能落在 ASCII 区，本来就会变，不能拿它当校验。
SINGLE_BYTE_ENCODINGS = {
    "ascii", "utf-8", "utf8", "latin-1", "latin1", "iso8859-1", "iso-8859-1",
    "cp1252", "windows-1252",
}

#: 私用区（PUA）：正常文本里不该出现。gb18030/GBK 对"没定义的字节对"会丢进私用区，
#: 所以一个读法解出 PUA 字符，基本可以断定这个读法是错的（挑读法时首要否决项）。
PUA_RE = re.compile(r"[\ue000-\uf8ff]")

#: "中文编码下的标点/符号"：全角标点、破折号、引号、数学/箭头符号等。
#: 用途是认下"没有汉字、但确实是中文编码"的文件 —— 例如 at88sc_datasheet.h 里
#: A8 43 在 gb18030 下是"–"、A1 DC 是"≤"，上下文 "(b4 – b7)" / "[N ≤ $10]" 完全讲得通；
#: 而 big5 会把它读成 8 个孤立的"每"，反倒"像中文"了。
CJK_SYMBOL_RE = re.compile(
    r"[\u2010-\u203b\u2044\u2052\u2070-\u209f\u20a0-\u20bf\u2100-\u214f"
    r"\u2190-\u21ff\u2200-\u22ff\u2460-\u24ff\u25a0-\u25ff\u2600-\u26ff"
    r"\u3000-\u303f\ufe30-\ufe4f\uff01-\uff60\uffe0-\uffe6]"
)
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
#: 单字节值占比判据：某个字节值占了 >90% 就认为是填充块/裸数据（见 binary_reason）
DOMINANT_BYTE_RATIO = 0.90
#: 占比判据的最小文件长度：太小的文件（如几行 ===== 分隔线）容易凑出高占比，不参与判定
DOMINANT_MIN_SIZE = 1024

#: CP1252/Latin-1 里"西方排版字符 + 拉丁字母"的允许集合，其余非 ASCII 视为非西文
ALLOWED_NONASCII = frozenset(
    WESTERN_PUNCT | {chr(c) for c in range(0xA0, 0x0250) if chr(c).isalpha()}
)
NONWESTERN_RE = re.compile(
    "[^\x00-\x7f" + re.escape("".join(sorted(ALLOWED_NONASCII))) + "]"
)

#: 无后缀但"确定是文本"的文件名：这些照常扫描；其余无后缀文件整类跳过（见 should_scan）。
#: 刻意不收 CHANGELOG：本仓库那 4 个 lwip*/CHANGELOG 是西文被误判成中文的假阳性，
#: 收进来只会把噪音请回来。要加就是往这个集合里添一个名字。
NOEXT_TEXT_NAMES = {
    "Makefile", "makefile", "GNUmakefile",
    "Kconfig", "Kbuild",
    "README", "LICENSE", "COPYING", "INSTALL", "configure", "Dockerfile",
}


# --------------------------------------------------------------------------
# 数据结构
# --------------------------------------------------------------------------

@dataclass
class Info:
    """单个文件的检测结果。"""
    path: Path
    rel: str
    size: int
    kind: str = "unknown"          # ascii/utf-8/chinese/western/ambiguous/forced/
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
    moji_hint: str = ""            # 疑似双重编码：检测器建议先试的中间编码
    moji_mid: str = ""             # 疑似双重编码：反解实际用上的中间编码
    moji_back: str | None = None   # 疑似双重编码：反解结果；None 表示反解不出来

    @property
    def ok(self) -> bool:
        return self.kind in ("ascii", "utf-8")


@dataclass
class Options:
    realdo: bool = False
    western: bool = False
    unknown: bool = False          # --unknown：未知编码的文件强制按 latin-1 保真解码
    multi: bool = False            # --multi：把"疑似双重编码"的文件反解回原文
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


def binary_reason(data: bytes) -> str:
    """
    内容层粗判二进制，返回命中的理由；空串表示"看着像文本"。
    四条判据（任何一条命中即算二进制）：
      1) 前 8KB 出现 NUL 字节；
      2) 前 8KB 控制字符占比 > 10%；
      3) 整文件一个 ASCII 字节都没有 —— 纯文本不会长这样（哪怕是纯中文 UTF-8，
         换行/空格/标点也必然是 ASCII 字节）；
      4) 单个字节值占比 > 90%（文件 ≥ 1KB），**且该字节不是可打印 ASCII** ——
         空白 flash 的 0xFF 填充、带文本头的镜像、0x00/0xAA/0xCC 填充块都属于这类。
         限定"非可打印 ASCII"是为了不误伤正经文本：仓库里 mbedtls 的 hash_file_5
         就是 1MB 全是 'a'，curl 的 test1003 有 97% 是 'A'，它们都是合格 ASCII 文本
         （本来也不需要转换），只有 0xFF/0x00 这类字节占绝对多数才说明这是填充物。

    为什么要有 3、4：后缀名单永远列不全。就是因为只靠"有 NUL / 控制字符多"这一条，
    当初 8 个全 0xFF 的空白 flash 镜像（既没 NUL 也没控制字符）被判成了文本，
    按 cp1252 转一遍就从 1MiB 涨到 2MiB，镜像直接报废——同样的内容只要换个后缀
    （例如 .dat）现在依然会被 3、4 拦住。
    """
    if not data:
        return ""
    head = data[:8192]
    if b"\x00" in head:
        return "含 NUL 字节"
    ctrl = len(head.translate(None, BINARY_PROBE_DELETE))   # C 层统计控制字节
    if ctrl / len(head) > 0.10:
        return "控制字符占比 %.0f%%" % (100.0 * ctrl / len(head))
    if len(data.translate(None, ASCII_DELETE)) == len(data):
        return "整文件不含任何 ASCII 字节"
    if len(data) >= DOMINANT_MIN_SIZE:
        top_byte, top = collections.Counter(head).most_common(1)[0]
        if top / len(head) > DOMINANT_BYTE_RATIO and not (0x20 <= top_byte < 0x7F):
            return "填充字节 0x%02X 占前 8KB 的 %.0f%%" % (top_byte, 100.0 * top / len(head))
    return ""


def looks_binary(data: bytes) -> bool:
    """按内容粗判二进制：binary_reason 的布尔投影（只给调用方一个 yes/no）。"""
    return bool(binary_reason(data))


def mojibake_score(text: str, cjk_run: int) -> tuple[int, str, str]:
    """
    判断一个"已经是合法 UTF-8"的文件是否其实是双重编码乱码（mojibake）。
    返回 (特征数, 说明, 建议的中间编码)，特征数 0 表示不像。
    注意：单看"文件里出现了乱码特征字符串"会误报——本脚本的源码、编码教程
    都会写到这些特征本身；所以强特征只认"连片重复"形态（真乱码文件里
    每个坏字都变成一组特征字，必然成片），弱特征则要求足够密度
    且文件里没有任何连续中文（真乱码文件里中文已经全被打散了）。

    第三个返回值是"反解双重编码时要先试哪个中间编码"：强特征是汉字形态的，
    说明原文的 UTF-8 字节被当 GBK 读了，反解走 gb18030；弱特征是西欧字母/排版
    符号连片，说明被当 Latin-1/CP1252 读了，反解走 latin-1。
    """
    pair = sum(text.count(p) for p in MOJIBAKE_PAIR)
    total = sum(text.count(m) for m in MOJIBAKE_STRONG)
    if pair or total >= 6:
        return max(pair, total), (
            "疑似 GBK 解 UTF-8 的双重编码（连续 %d 处、共 %d 处）" % (pair, total)), "gb18030"
    if cjk_run < 2:
        longest = max((m.end() - m.start()
                       for m in MOJIBAKE_LATIN1_RUN_RE.finditer(text)), default=0)
        if longest:
            return longest, ("疑似 Latin-1/CP1252 解 UTF-8 的双重编码"
                             "（出现 %d 个连片西欧字符）" % longest), "latin-1"
    return 0, "", ""


def try_unmojibake(text: str, hint: str = "") -> tuple[str, str] | None:
    """
    反解"双重编码"（--multi 用）：文件本身是合法 UTF-8，但内容是"真正的原文字节
    被按某个别的编码读了一遍"的产物。把中间编码反着走一遍即可还原，例如
    "ä½ å¥½" --latin-1--> E4 BD A0 E5 A5 BD --utf-8--> "你好"。

    返回 (还原后的文本, 用到的中间编码)；只有"还原结果本身仍是合法 UTF-8"才认账，
    否则返回 None。这条校验正是误报保护：正常 UTF-8 文本反解后几乎必然不是合法
    UTF-8，于是会在这里被挡下，交给人判断，绝不硬写。
    """
    order = [c for c in (hint, "latin-1", "cp1252", "gb18030", "big5") if c]
    tried: set[str] = set()
    for mid in order:
        if mid in tried:
            continue
        tried.add(mid)
        try:
            raw = text.encode(mid)
        except (UnicodeEncodeError, LookupError):
            continue
        try:
            back = raw.decode("utf-8")
        except UnicodeDecodeError:
            continue
        if mojibake_score(back, count_cjk(back)[1])[0]:
            continue          # 还原后还带着乱码特征，说明方向不对
        return back, mid
    return None


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
            score, why, hint = mojibake_score(text_utf8, info.run)
            if score and hint == "latin-1" and try_unmojibake(text_utf8, hint) is None:
                # 弱特征（西欧字母/排版符号"连片 3 个"）在正常文档里也会满足：一串
                # ’ “ ” – ° µ © 就够了，所以这条判据本身误报率很高。加一道实证——
                # 反解不回合法 UTF-8 的，就不算双重编码，按普通 UTF-8 处理。
                # （强特征"销斤拷"连片是汉字形态，正常文档不会出现，保持原样直接报。）
                score = 0
            if score:
                info.kind = "mojibake-suspect"
                info.note = why
                info.moji_hint = hint
        return info

    # 用户用 --enc 指定了源编码：这就是权威判定，不再走下面的自动识别。
    # （已经是合法 UTF-8 的文件在上面就返回了 —— 对它们没什么可"转"的，
    #  所以 --enc 只作用于"非 UTF-8"的文件。）
    if opts.encodings:
        for enc in opts.encodings:
            t = try_decode(data, enc)
            if t is None:
                continue
            info.encoding = enc
            info.cjk, info.run = count_cjk(t)
            info.kind = "forced"
            info.note = "按 --enc %s 认定（未做自动判定）" % enc
            return info
        info.kind = "unknown"
        info.note = "指定的 --enc %s 都解不开这个文件" % "/".join(opts.encodings)
        return info

    # 候选编码逐个试
    decoded: dict[str, str] = {}
    for enc in (*opts.encodings, *CHINESE_ENCODINGS, *WESTERN_ENCODINGS):
        if enc in decoded:
            continue
        t = try_decode(data, enc)
        if t is not None:
            decoded[enc] = t

    # 先看看"西文读法"可不可信 —— 下面判断"中文读法带私用区"时要用到
    western_hit = None
    for enc in (*opts.encodings, *WESTERN_ENCODINGS):
        t = decoded.get(enc)
        if t is not None and western_plausible(t):
            western_hit = enc
            break

    # 1) 中文读法：不再"谁先解出汉字就用谁"，而是给每个候选读法打分挑最讲得通的。
    #    打分优先级（元组从前往后比）：
    #      a) 没有私用区字符 —— gb18030 遇到没定义的字节对会把它丢进私用区
    #         （U+E000-U+F8FF），正常文本不会出现；Big5 文本被当 gb18030 读就会这样
    #         （仓库里 60+ 个文件），以前"先到先得"正好每次都选中这个错读法；
    #      b) 连续中文更长；c) 汉字更多。
    #    同分保持 CHINESE_ENCODINGS 的顺序（gb18030 在前）—— 它是 GB2312/GBK 的超集、
    #    大陆代码里最常见；仓库实测 29 个文件两种读法同分，选 gb18030 是对的。
    #    另外：读法里带私用区说明这个"中文读法"本身就不可信（例如 uclibc 那个
    #    带德语变音的 locale 测试），此时若有可信的西文读法，就让给西文那条保守路径。
    best = None
    for enc in (*opts.encodings, *CHINESE_ENCODINGS):
        t = decoded.get(enc)
        if t is None:
            continue
        cjk, run = count_cjk(t)
        if not (cjk and run >= opts.min_run):
            continue
        dirty = PUA_RE.search(t) is not None
        if dirty and western_hit is not None:
            continue
        key = (not dirty, run, cjk)
        if best is None or key > best[0]:
            best = (key, enc, cjk, run, dirty)
    if best is not None:
        _, enc, cjk, run, dirty = best
        info.kind = "chinese"
        info.encoding = enc
        info.cjk, info.run = cjk, run
        if dirty:
            info.note = "读法含私用区字符，该文件本身可能已是乱码，请转换后确认"
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

    # 3) 一个汉字都没有，但中文编码解出来的是"标点/数学符号"这类字符、且不带私用区：
    #    这就是"中文编码存标点"的文件（如 at88sc_datasheet.h 里的 – 和 ≤），该按中文编码转。
    #    放在西文判据之后 —— 先让真正像西文的文件走西文那条路，别抢它的活。
    for enc in (*opts.encodings, *CHINESE_ENCODINGS):
        t = decoded.get(enc)
        if t is None or PUA_RE.search(t):
            continue
        foreign = [c for c in t if ord(c) > 127]
        if foreign and all(CJK_SYMBOL_RE.match(c) for c in foreign):
            info.kind = "chinese"
            info.encoding = enc
            info.cjk, info.run = count_cjk(t)
            info.note = "中文编码下的标点/符号（无汉字）：%s" % "".join(
                dict.fromkeys(foreign))[:16]
            return info

    # 4) 能按中文编码解出字，但不成词 —— 交给人判断（同样先挑不带私用区的）
    best = None
    for enc in (*CHINESE_ENCODINGS,):
        t = decoded.get(enc)
        if t is None:
            continue
        cjk, run = count_cjk(t)
        if not cjk:
            continue
        key = (PUA_RE.search(t) is None, cjk)
        if best is None or key > best[0]:
            best = (key, enc, cjk, run)
    if best is not None:
        _, enc, cjk, run = best
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

    唯一的例外是 HARD_BINARY_EXT（固件、镜像、裸视频、签名块、位图这类纯二进制后缀，
    见文件头常量）：它们即便被点名也不碰。它们的内容层拦截（looks_binary）靠不住，
    误判一次就是不可逆的损坏，所以按后缀直接拒掉，绝不给"点名就能覆盖"的机会。
    """
    ext = path.suffix.lower()
    if ext in HARD_BINARY_EXT:
        return False, "固件/镜像等纯二进制格式，一律不转换"
    if explicit:
        return True, ""
    # 无后缀文件（Makefile/Kconfig/README/configure，以及各种无后缀测试夹具）整类跳过。
    # 理由：这类文件量大（本仓库 4000+），后缀又给不出任何信号 —— 里面既有 8MB 的 ctags
    # 索引、也有上千个 ascii 夹具，扫进来纯是噪音和误判；真正需要转的极少。
    # 但白名单里的名字（Makefile/Kconfig/README…）确定是文本，照常处理；
    # 需要处理别的无后缀文件时点名叫上即可（explicit 分支在上面就放行了）。
    if not ext:
        if path.name not in NOEXT_TEXT_NAMES:
            return False, "无后缀文件（扫目录时默认跳过，点名指定即可处理）"
    if opts.exts and ext not in opts.exts:
        return False, "后缀不在白名单"
    if ext in BINARY_EXT:
        return False, "二进制后缀"
    if ext in SKIP_TEXT_EXT:
        return False, "翻译/测试夹具类后缀，默认不碰（点名可处理）"
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

    # 校验 1：回环还原必须与原件逐字节相同（这是"无损"的真正保证：任何一步都能反着走回去）
    if new.decode("utf-8").encode(info.encoding) != raw:   # type: ignore[arg-type]
        raise RuntimeError("回环校验失败")

    # 校验 2：ASCII 骨架（去掉所有 >=0x80 的字节）必须完全一致。
    # 注意这条**只对单字节编码成立**：GBK/GB18030/Big5 的双字节字尾巴可能落在
    # 0x40-0x7E（ASCII 区），例如 "–" = A8 43、尾字节就是字母 C，转成 UTF-8 后这个
    # ASCII 字节必然消失。以前对双字节编码也套这条，导致 200+ 个真 GBK/Big5 文件
    # 一律报"ASCII 骨架发生变化"转不了（本仓库 234 个中文文件全卡在这），
    # 而它想防的"代码逻辑被改动"其实由校验 1 保证。
    if info.encoding.lower() in SINGLE_BYTE_ENCODINGS:     # type: ignore[union-attr]
        if bytes(b for b in raw if b < 0x80) != bytes(b for b in new if b < 0x80):
            raise RuntimeError("ASCII 骨架发生变化")

    if path.suffix.lower() in MARKUP_EXT and opts.update_html_charset:
        new = rewrite_charset(new, info.encoding)      # type: ignore[arg-type]

    if backup is not None:
        backup.save(path, info.encoding, raw)          # type: ignore[arg-type]
    path.write_bytes(new)
    info.converted = True


def do_unmojibake(path: Path, info: Info, opts: Options, backup: Backup | None) -> None:
    """
    --multi 的写盘路径：把"疑似双重编码"的文件反解回原文。

    这条路径的校验和 do_convert 不一样，因为这里是**内容真的变了**（不是换编码）：
    回环校验没有意义，唯一的安全网是 try_unmojibake 里那条"还原结果必须仍是合法
    UTF-8"——反解不出来就抛错，绝不让半个乱码写进去。
    """
    if info.moji_back is None or not info.moji_mid:
        raise RuntimeError("反解失败：按 latin-1/cp1252/gb18030/big5 都还原不出合法 UTF-8")
    raw = path.read_bytes()
    new = info.moji_back.encode("utf-8")
    if new == raw:
        raise RuntimeError("反解结果与原文相同，无需转换")
    if backup is not None:
        # 中间编码记进 manifest，回退时只用于说明"这份原件本该按什么反解"
        backup.save(path, "utf-8 + %s-mojibake" % info.moji_mid, raw)
    path.write_bytes(new)
    info.converted = True
    info.note = (info.note + " | " if info.note else "") + "已按 %s 反解" % info.moji_mid


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
    "forced": "指定编码",
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

ACTION_ORDER = {"chinese": 0, "forced": 0, "ambiguous": 1, "western": 2,
                "mojibake-suspect": 3, "utf-16": 4, "unknown": 5}


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
                "mojibake_mid": i.moji_mid,       # --multi 实际用上的中间编码
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
               "  convert_to_utf8.py src --unknown --realdo  # 未知编码强制按 latin-1 保真转\n"
               "  convert_to_utf8.py src --multi --realdo    # 双重编码乱码反解回原文\n"
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
                    help="要处理的目录或文件，可混着写多个；点名指定的文件不受后缀过滤限制"
                         "（固件/镜像/裸视频/签名/位图等纯二进制格式例外，一律不碰）；"
                         "扫目录时跳过没有后缀的文件（Makefile/Kconfig/README 这类，点名即可处理）；"
                         "支持通配符（内部展开）与 @清单文件；扫描当前目录请显式写 .")
    mode = ap.add_mutually_exclusive_group()
    mode.add_argument("-r", "--realdo", action="store_true",
                      help="真正执行转换，会写文件（默认只报告，即 dry-run）")
    mode.add_argument("-n", "--dry-run", action="store_true",
                      help="只报告不写文件（默认行为，写出来是为了自文档化）")
    ap.add_argument("-w", "--western", action="store_true",
                    help="同时转换西文假乱码（CP1252 的 ’ “ ” – ° µ 等）")
    ap.add_argument("--unknown", action="store_true",
                    help="未知编码（任何候选编码都解不出）的文件强制按 latin-1 逐字节保真"
                         "解码为 UTF-8；非 ASCII 字节 1 变 2、体积会变大，但字节可无损还原")
    ap.add_argument("--multi", action="store_true",
                    help="把“疑似双重编码”的乱码反解回原文（如 ä½ å¥½ → 你好）；"
                         "还原结果不是合法 UTF-8 就跳过并说明原因，绝不硬写")
    ap.add_argument("--ambiguous", choices=["skip", "chinese", "western"], default="skip",
                    help="孤立汉字文件如何处理，默认 skip（只报告）")
    ap.add_argument("--enc", action="append", default=[], metavar="ENC",
                    help="强制指定源编码，可重复（如 --enc gb18030 --enc big5）；"
                         "指定后就按它转，不再自动判定（可解开的第一个生效；"
                         "都解不开则记为未知编码并说明，不会退回自动猜）")
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
        unknown=args.unknown,
        multi=args.multi,
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
    skipped_noext = 0
    for path, explicit in iter_files(roots, opts):
        ok, why = should_scan(path, opts, explicit)
        if not ok:
            if not path.suffix:
                skipped_noext += 1          # 这类量大，逐条打印会刷屏，只在汇总里报总数
            # 点名的文件被拒（硬二进制、无后缀等）必须明说，不能静默跳过
            if opts.verbose or explicit:
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
        why_bin = binary_reason(data)
        if why_bin:
            # 点名的文件必须明说；扫目录时挂上 -v 也能看到是被哪条判据拦下的
            if explicit or opts.verbose:
                print("跳过 %s（内容像二进制：%s，未转换）" % (path, why_bin), file=sys.stderr)
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
        if info.kind in ("chinese", "forced"):
            # forced = 用户用 --enc 点明了源编码，按他说的转
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
            # --multi：反解双重编码。这里就把"能不能反解"验一遍，dry-run 与 realdo
            # 看到的是同一个结论；反解不出来就照旧交给人，绝不硬写。
            if opts.multi:
                got = try_unmojibake(data.decode("utf-8"), info.moji_hint)
                if got is None:
                    info.action = "跳过（--multi 反解失败：还原结果不是合法 UTF-8）"
                else:
                    info.moji_back, info.moji_mid = got
                    want = True
            else:
                info.action = "跳过（需人工确认，或用 --multi 反解）"
        elif info.kind == "unknown":
            # --unknown：没有任何候选编码解得出，强制按 latin-1 逐字节保真解码。
            # latin-1 对任意字节都成立，所以必定成功，且字节可无损还原、能回退；
            # 代价是非 ASCII 字节 1 变 2，体积会涨——这里把预计体积标出来。
            if opts.unknown:
                info.encoding = "latin-1"
                want = True
                info.note = ((info.note + " | ") if info.note else "") + (
                    "强制 latin-1 保真解码，体积 %d → %d 字节（+%.0f%%）"
                    % (len(data), len(data) + info.nonascii,
                       100.0 * info.nonascii / max(1, len(data))))
            else:
                info.action = "跳过（需 --unknown 强制）"
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
                    elif info.kind == "mojibake-suspect":
                        do_unmojibake(path, info, opts, backup)     # 内容真变了，单走一条
                        info.action = "已反解双重编码"
                    else:
                        do_convert(path, info, opts, backup)
                        info.action = "已转换"
                except Exception as exc:               # noqa: BLE001
                    info.action = "失败"
                    info.note = (info.note + " | " if info.note else "") + str(exc)
            else:
                if info.kind in ("chinese", "forced", "western", "ambiguous",
                                 "mojibake-suspect", "unknown"):
                    info.action = "将转换（dry-run）"

        if info.kind not in ("ascii", "utf-8", "empty") or opts.verbose:
            results.append(info)

    # ---------------- 报告 ----------------
    results.sort(key=lambda i: (ACTION_ORDER.get(i.kind, 9), i.rel))
    interesting = [i for i in results if i.kind not in ("ascii", "utf-8")]

    if opts.list_only:
        # 只列"确实会被转换"的：加不加 --western/--unknown/--multi 会改变结论，
        # 所以按动作判定，而不是按类别判定
        for i in interesting:
            if i.converted or i.action == "将转换（dry-run）":
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
        "指定编码": counts["forced"],
        "西文假乱码": counts["western"],
        "待确认": counts["ambiguous"],
        "疑似双重编码": counts["mojibake-suspect"],
        "其他非 UTF-8": counts["utf-16"] + counts["unknown"],
    }
    tail = ["空文件 %d" % counts["empty"]] if counts["empty"] else []
    parts = ["%s %d" % (k, v) for k, v in summary.items() if v] + tail
    emit("扫描结果：" + ("，".join(parts) if parts else "没有非 UTF-8 文件"))
    if skipped_noext:
        emit("跳过无后缀文件 %d 个（Makefile/Kconfig/README 这类；需要处理就点名指定）"
             % skipped_noext)
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
        if opts.multi:
            failed = [i for i in results if i.kind == "mojibake-suspect" and not i.converted]
            if failed:
                emit("提示：%d 个疑似双重编码文件反解失败（还原出来不是合法 UTF-8），已原样保留"
                     % len(failed))
        else:
            moji = [i for i in results if i.kind == "mojibake-suspect"]
            if moji:
                emit("提示：有 %d 个疑似双重编码文件未处理，加 --multi 可尝试反解回原文" % len(moji))
        if opts.unknown:
            left = [i for i in results if i.kind == "unknown" and not i.converted]
            if left:
                emit("提示：%d 个未知编码文件未能强制转换" % len(left))
        else:
            unk = [i for i in results if i.kind == "unknown"]
            if unk:
                emit("提示：有 %d 个未知编码文件未处理，加 --unknown 可强制按 latin-1 保真解码"
                     % len(unk))
    else:
        pending = (counts["chinese"] + counts["forced"]
                   + (counts["western"] if opts.western else 0)
                   + (counts["mojibake-suspect"] if opts.multi else 0)
                   + (counts["unknown"] if opts.unknown else 0))
        if pending:
            emit("dry-run，未写任何文件。加 --realdo 执行转换。")
        elif counts["western"] and not opts.western:
            emit("提示：发现 %d 个西文假乱码文件（英文里的 ’ “ ” – ° µ），加 --western 可一并转换。"
                  % counts["western"])
        if counts["mojibake-suspect"] and not opts.multi:
            emit("提示：%d 个疑似双重编码文件，加 --multi 可尝试反解回原文。"
                 % counts["mojibake-suspect"])
        if counts["unknown"] and not opts.unknown:
            emit("提示：%d 个未知编码文件，加 --unknown 可强制按 latin-1 保真解码（体积会变大）。"
                 % counts["unknown"])

    if opts.json_path:
        write_json_report(opts.json_path, opts, roots, counts, results, summary)

    if opts.check and (counts["chinese"] + counts["forced"]
                       + (counts["western"] if opts.western else 0)
                       + (counts["mojibake-suspect"] if opts.multi else 0)
                       + (counts["unknown"] if opts.unknown else 0)):
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

        # 固件/镜像/裸视频等纯二进制格式：连点名也不碰（.img/.jffs2/.jffs/.dtb/.yuv）
        # 夹具故意用全 0xFF 的空白镜像：没有 NUL、没有控制字符，looks_binary() 判不出来，
        # 只能靠后缀硬拦——这正是真实仓库里镜像被当 cp1252 转换后体积翻倍的成因。
        selimg = make_tree("selimg")
        img_before = b"\xff" * 4096
        (selimg / "board" / "flash.img").write_bytes(img_before)
        (selimg / "board" / "rootfs.jffs2").write_bytes(img_before)
        (selimg / "board" / "frame.yuv").write_bytes(img_before)
        (selimg / "board" / "fixture.input").write_bytes(gbk_body.encode("gbk"))
        rc, out = run_raw([str(selimg / "board" / "frame.yuv"), "--realdo"], tmp)
        check("点名 .yuv 一律不改动",
              (selimg / "board" / "frame.yuv").read_bytes() == img_before and "纯二进制" in out, out)
        rc, out = run_raw([str(selimg), "--western", "--realdo", "-q"], tmp)
        check("扫目录时 .img/.jffs2/.yuv 被跳过（--western 也不行）",
              (selimg / "board" / "flash.img").read_bytes() == img_before
              and (selimg / "board" / "rootfs.jffs2").read_bytes() == img_before
              and (selimg / "board" / "frame.yuv").read_bytes() == img_before, out)
        check("扫目录时 .input 夹具被跳过",
              (selimg / "board" / "fixture.input").read_bytes() == gbk_body.encode("gbk"), out)
        check("同目录里的普通文本仍照常转换",
              try_decode((selimg / "board" / "board.c").read_bytes(), "utf-8") is not None, out)
        # .input 是文本夹具而非二进制，只做"扫目录跳过"，点名仍应能处理
        rc, out = run_raw([str(selimg / "board" / "fixture.input"), "--realdo", "-q"], tmp)
        check("点名 .input 仍可处理（软排除）",
              try_decode((selimg / "board" / "fixture.input").read_bytes(), "utf-8") is not None, out)

        # --unknown：任何候选编码都解不出的"未知编码"文件，强制按 latin-1 逐字节保真转
        selu = make_tree("selu")
        unk_bytes = b"\x81\xff" + b"abc\n"
        (selu / "board" / "blob.dat").write_bytes(unk_bytes)
        check("夹具确实是『未知编码』且不像二进制",
              classify(unk_bytes, Options()).kind == "unknown" and not looks_binary(unk_bytes),
              classify(unk_bytes, Options()).kind)
        rc, out = run_raw([str(selu / "board" / "blob.dat"), "--realdo"], tmp)
        check("无 --unknown 时未知编码文件原样不动",
              (selu / "board" / "blob.dat").read_bytes() == unk_bytes, out)
        rc, out = run_raw([str(selu / "board" / "blob.dat"), "--unknown", "--realdo", "-q"], tmp)
        got_unk = (selu / "board" / "blob.dat").read_bytes()
        check("--unknown 强制转成合法 UTF-8", try_decode(got_unk, "utf-8") is not None, out)
        check("--unknown 逐字节可还原（能回退）",
              got_unk.decode("utf-8").encode("latin-1") == unk_bytes, out)
        rc, out = run_raw([str(selimg / "board" / "flash.img"), "--unknown", "--realdo"], tmp)
        check("--unknown 也越不过硬二进制名单",
              (selimg / "board" / "flash.img").read_bytes() == img_before, out)

        # 签名块 / 位图 同样按后缀硬拦，连 --unknown 也覆盖不了
        (selimg / "board" / "itron.tar.sign").write_bytes(b"\x81\xff" + b"sig\n")   # 本来是"未知编码"
        (selimg / "board" / "testimg.ppm").write_bytes(b"P6\n1 1\n255\n\x81\xff\x00")
        (selimg / "board" / "mask.pgm").write_bytes(b"P5\n1 1\n255\n\x81\xff")
        rc, out = run_raw([str(selimg / "board" / "itron.tar.sign"),
                           str(selimg / "board" / "testimg.ppm"),
                           str(selimg / "board" / "mask.pgm"),
                           "--unknown", "--realdo"], tmp)
        check("点名 .sign/.ppm/.pgm 一律不改动",
              (selimg / "board" / "itron.tar.sign").read_bytes() == b"\x81\xff" + b"sig\n"
              and (selimg / "board" / "testimg.ppm").read_bytes() == b"P6\n1 1\n255\n\x81\xff\x00"
              and (selimg / "board" / "mask.pgm").read_bytes() == b"P5\n1 1\n255\n\x81\xff"
              and out.count("纯二进制") == 3, out)

        # 内容层加固：没有后缀保护的纯二进制块，必须自己认出来（当初 8 个 flash 镜像
        # 就是"全 0xFF、既没 NUL 也没控制字符"，只靠后缀名单漏掉一个就报废）
        selb2 = make_tree("selb2")
        blank = b"\xff" * 4096                       # 空白 flash 镜像的内容
        mixed = b"\xff" * 3900 + b"header\n" * 20
        (selb2 / "board" / "blank.dat").write_bytes(blank)   # 后缀不在任何名单里
        (selb2 / "board" / "mixed.dat").write_bytes(mixed)
        check("全 0xFF 空白块被判为二进制（当初就是漏了这条）", looks_binary(blank) is True)
        check("带少量 ASCII 的填充块也被判为二进制", looks_binary(mixed) is True)
        check("短文件不参与单字节占比判定", looks_binary(b"\xff" * 10 + b"a") is False)
        check("单字节占比高但字节可打印时不算二进制（不误伤 'a'/'A'/'#' 组成的真文本）",
              looks_binary(b"a" * 4096) is False and looks_binary(b"A" * 4096) is False
              and looks_binary(b"#" * 3900 + b"exec 13>&-\n" * 20) is False)
        check("正常源码不被判为二进制",
              looks_binary(b"int main(void) { return 0; }\n") is False)
        check("正常中文 UTF-8 不被判为二进制",
              looks_binary("/* 中文注释 */\nint a = 1;\n".encode("utf-8")) is False)
        rc, out = run_raw([str(selb2 / "board" / "blank.dat"), "--western", "--realdo"], tmp)
        check("点名无后缀空白镜像被内容判据拦住，并说明理由",
              (selb2 / "board" / "blank.dat").read_bytes() == blank and "ASCII" in out, out)
        rc, out = run_raw([str(selb2), "--western", "--realdo", "-q"], tmp)
        check("扫目录时无后缀二进制块同样被拦住",
              (selb2 / "board" / "blank.dat").read_bytes() == blank
              and (selb2 / "board" / "mixed.dat").read_bytes() == mixed, out)
        check("同目录里的普通文本仍照常转换",
              try_decode((selb2 / "board" / "board.c").read_bytes(), "utf-8") is not None, out)

        # --multi：把"双重编码"乱码反解回原文（内容真的变了，不是换编码）
        selm = make_tree("selm")
        true_text = "/* 清空计数器，开始计数 */\nint a = 1;\n"
        moji_bytes = true_text.encode("utf-8").decode("latin-1").encode("utf-8")
        (selm / "board" / "moji.c").write_bytes(moji_bytes)
        check("夹具确实被判为『疑似双重编码』",
              classify(moji_bytes, Options()).kind == "mojibake-suspect",
              classify(moji_bytes, Options()).kind)
        rc, out = run_raw([str(selm / "board" / "moji.c"), "--realdo"], tmp)
        check("无 --multi 时双重编码文件原样不动",
              (selm / "board" / "moji.c").read_bytes() == moji_bytes, out)
        rc, out = run_raw([str(selm / "board" / "moji.c"), "--multi", "--realdo", "-q"], tmp)
        check("--multi 反解回真正原文",
              (selm / "board" / "moji.c").read_bytes() == true_text.encode("utf-8"), out)

        # 弱特征假阳性：一串正常的 ’ “ ” – ° µ © 连片，不该再被误报成双重编码
        deco_text = "/* \u00b0\u00b1\u00b2\u00b3\u00b4\u00b5\u00b6\u00b7\u00b8\u00b9\u00ba */\nint c = 3;\n"
        (selm / "board" / "deco.c").write_bytes(deco_text.encode("utf-8"))
        check("排版符号连片不再误报为双重编码",
              classify(deco_text.encode("utf-8"), Options()).kind == "utf-8",
              classify(deco_text.encode("utf-8"), Options()).kind)
        rc, out = run_raw([str(selm / "board" / "deco.c"), "--multi", "--realdo", "-q"], tmp)
        check("该假阳性在 --multi 下也不动",
              (selm / "board" / "deco.c").read_bytes() == deco_text.encode("utf-8"), out)

        # --multi 的误报保护：强特征（销斤拷连片）报出来之后，反解不出来也必须原样保留
        guard_text = "x" * 10 + "\u9500\u65a4\u62f7" * 3 + "y" * 10 + "\n"
        (selm / "board" / "guard.c").write_bytes(guard_text.encode("utf-8"))
        check("强特征夹具被判『疑似双重编码』但反解不出来",
              classify(guard_text.encode("utf-8"), Options()).kind == "mojibake-suspect"
              and try_unmojibake(guard_text, "gb18030") is None)
        rc, out = run_raw([str(selm / "board" / "guard.c"), "--multi", "--realdo", "-q"], tmp)
        check("--multi 反解失败时原样保留，绝不硬写",
              (selm / "board" / "guard.c").read_bytes() == guard_text.encode("utf-8"), out)
        check("--multi 反解失败会在报告里说明", "反解失败" in out, out)

        # 无后缀文件：白名单（Makefile/Kconfig/README…）照常处理，其余整类跳过
        seln = make_tree("seln")
        for nm in ("Makefile", "Kconfig", "README", "somefixture"):
            (seln / "board" / nm).write_bytes(gbk_body.encode("gbk"))
        rc, out = run_raw([str(seln), "--realdo", "-q"], tmp)
        check("无后缀白名单（Makefile/Kconfig/README）照常转换",
              all(try_decode((seln / "board" / nm).read_bytes(), "utf-8") is not None
                  for nm in ("Makefile", "Kconfig", "README")), out)
        check("白名单外的无后缀文件被跳过",
              (seln / "board" / "somefixture").read_bytes() == gbk_body.encode("gbk"), out)
        check("无后缀跳过数写进汇总", "跳过无后缀文件" in out, out)
        check("同目录有后缀的文件仍照常转换",
              try_decode((seln / "board" / "board.c").read_bytes(), "utf-8") is not None, out)
        rc, out = run_raw([str(seln / "board" / "somefixture"), "--realdo", "-q"], tmp)
        check("点名白名单外的无后缀文件仍可处理",
              try_decode((seln / "board" / "somefixture").read_bytes(), "utf-8") is not None, out)

        # 翻译/测试夹具类后缀（.po/.proto/.options/.expected/.input）：扫目录跳过，点名可处理
        selfix = make_tree("selfix")
        fixture_exts = (".po", ".proto", ".options", ".expected", ".input", ".o")
        for e in fixture_exts:
            (selfix / "board" / ("fixture" + e)).write_bytes(gbk_body.encode("gbk"))
        rc, out = run_raw([str(selfix), "--realdo", "-q"], tmp)
        check("扫目录时翻译/夹具类后缀被跳过",
              all((selfix / "board" / ("fixture" + e)).read_bytes() == gbk_body.encode("gbk")
                  for e in fixture_exts), out)
        check("同目录普通源码仍照常转换",
              try_decode((selfix / "board" / "board.c").read_bytes(), "utf-8") is not None, out)
        rc, out = run_raw([str(selfix / "board" / "fixture.po"), "--realdo", "-q"], tmp)
        check("点名 .po 仍可处理（软排除）",
              try_decode((selfix / "board" / "fixture.po").read_bytes(), "utf-8") is not None, out)
        # .o 早就在二进制名单里（软跳过）：扫目录不看，点名时由内容判据兜底
        real_obj = b"\x7fELF\x02\x01\x01\x00" + b"\x00" * 64
        (selfix / "board" / "real.o").write_bytes(real_obj)
        rc, out = run_raw([str(selfix / "board" / "real.o"), "--realdo"], tmp)
        check("点名真正的 .o（ELF 内容）被内容判据拦下",
              (selfix / "board" / "real.o").read_bytes() == real_obj and "二进制" in out, out)

        # --enc：用户点明了编码就直接用，不再自动猜（原来自动判定会把指定值无视掉）
        dat_bytes = (b"/* b4 \xa8\x43 b7 */\n"
                     b"/* ER \xa8\x43 Encryption Required */\n"
                     b"[N \xa1\xdc $10] [N bytes]\n")
        di = classify(dat_bytes, Options())
        check("无汉字但中文编码存标点的文件被认成 gb18030",
              di.kind == "chinese" and di.encoding == "gb18030",
              "%s/%s" % (di.kind, di.encoding))
        fi = classify(dat_bytes, Options(encodings=("gb18030",)))
        check("--enc gb18030 直接认定，不再猜",
              fi.kind == "forced" and fi.encoding == "gb18030",
              "%s/%s" % (fi.kind, fi.encoding))
        check("--enc big5 也照用户说的来（不越权改成 gb18030）",
              classify(dat_bytes, Options(encodings=("big5",))).encoding == "big5")
        bi = classify(b"\xff\xff\xff not big5", Options(encodings=("big5",)))
        check("--enc 指定的编码解不开时明说，不退回瞎猜",
              bi.kind == "unknown" and "--enc" in bi.note, "%s / %s" % (bi.kind, bi.note))
        # 端到端：强制 cp1252 后不必再加 --western
        selenc = make_tree("selenc")
        enc_text = "/* the peripheral\u2019s registers, N\u00b0 0 */\nint d = 4;\n"
        (selenc / "board" / "west.c").write_bytes(enc_text.encode("cp1252"))
        rc, out = run_raw([str(selenc / "board" / "west.c"), "--realdo", "-q"], tmp)
        check("不加 --enc 时西文文件不转（需 --western）",
              (selenc / "board" / "west.c").read_bytes() == enc_text.encode("cp1252"), out)
        rc, out = run_raw([str(selenc / "board" / "west.c"), "--enc", "cp1252",
                           "--realdo", "-q"], tmp)
        got_enc = (selenc / "board" / "west.c").read_bytes()
        check("--enc cp1252 不用 --western 也能转",
              try_decode(got_enc, "utf-8") is not None and "peripheral\u2019s" in got_enc.decode("utf-8"),
              out)

        # 挑读法：Big5 文本被当 gb18030 读会解出私用区字符，现在改挑 big5
        b5_bytes = "/* \u7528\u4f86\u8a08\u7b97code\u88abrun\u5230\u6b21\u6578 */\nint a = 1;\n".encode("big5")
        g_read = try_decode(b5_bytes, "gb18030")
        check("gb18030 读 Big5 会解出私用区字符（这就是当初判错的原因）",
              g_read is not None and PUA_RE.search(g_read) is not None)
        bi2 = classify(b5_bytes, Options())
        check("Big5 文本现在被判成 big5",
              bi2.kind == "chinese" and bi2.encoding == "big5",
              "%s/%s" % (bi2.kind, bi2.encoding))
        check("真 GBK 中文不会被翻成 big5",
              classify("/* 设置设备类型，提供接口给外部 */\n".encode("gb18030"), Options()).encoding
              == "gb18030")

        # 双字节编码的 ASCII 尾字节不再触发"ASCII 骨架"误判
        # （GBK 的 "–" = A8 43，尾字节 0x43 就是字母 C；这是 234 个中文文件失败的主因）
        seldash = make_tree("seldash")
        dash_text = "/* b4 \u2013 b7 range */\nint a = 1;\n"
        (seldash / "board" / "dash.c").write_bytes(dash_text.encode("gb18030"))
        rc, out = run_raw([str(seldash / "board" / "dash.c"), "--realdo", "-q"], tmp)
        got_dash = try_decode((seldash / "board" / "dash.c").read_bytes(), "utf-8")
        check("含 ASCII 尾字节的 GBK 文件现在能转成功",
              got_dash is not None and "\u2013" in got_dash, out)

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
