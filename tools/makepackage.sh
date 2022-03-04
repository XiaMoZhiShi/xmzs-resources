#!/bin/bash
set -e

readonly BUILD_DIR="$PWD/build";

function changeDir()
{
    local target="$1"
    echo "更改当前目录到$target..."

    cd "$target"
}

function makepack()
{
    local directory="$1"
    local directoryName="${directory##*/}"
    local finalName="${directoryName//pack_/}"

    local option_gen="pack_directory = '$directory'
output_file_path = '$PWD/build/${directoryName//pack_/}.zip'
$(cat "$directory/config.toml")"

    echo "$option_gen" | tools/packsquash || echo "$option_gen"
    sha1sum "$PWD/build/$finalName.zip" | cut -d ' ' -f1 > "$PWD/build/$finalName"-sha1
}

function makedir()
{
    local target="$1"

    echo "makedir $1..."
    if [ ! -d "$1" ]; then
        echo "$1 不存在，将创建此目录"
    fi;
}

echo "初始化submodule"
git submodule update --init --recursive

makedir "$BUILD_DIR"

for d in ./src_*; do
    outName="${d/src/pack}"
    makedir "$outName"
done;

for s in tools/ext_*; do
    echo "运行扩展脚本: $s"
    "$s"
done;

for d in pack_* ;do
    echo "创建压缩文档: $d"
    makepack "$PWD/$d"
done;

echo "完成!"