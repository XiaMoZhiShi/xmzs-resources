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

echo "创建目录..."
if [ ! -d "$BUILD_DIR" ];then
    mkdir -vp "$BUILD_DIR"
fi

echo "运行扩展脚本..."
for s in tools/ext_*; do
    "$s"
done;

echo "创建压缩文档..."
for d in pack_* ;do
    makepack "$PWD/$d"
done;

echo "完成!"