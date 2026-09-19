#!/bin/bash

#if unnecessary, please do not modify following code
set -u

scriptfile="$0"
scriptname="$(basename "$scriptfile")"
fengming_dir="${FENGMING_DIR:-}"

if [ -z "$fengming_dir" ]; then
    echo "ERROR: 环境变量 FENGMING_DIR 未设置" >&2
    exit 1
fi

target="${fengming_dir}/fm_cmd_script/fm-convert_to_utf8.py"

if [ ! -f "$target" ]; then
    echo "ERROR:file fm-convert_to_utf8.py not exist: $target" >&2
    exit 1
fi

exec python3 "$target" "$@"