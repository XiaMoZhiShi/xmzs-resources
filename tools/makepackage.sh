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
    local name="$2"

    local option;
    option="$(sed "s#ROOT#$directory#g" tools/packsquash-config | sed "s#OUTNAME#$name#g")"

    echo "$option" | tools/packsquash
    sha1sum "build/$name.zip" | cut -d ' ' -f1 > "build/$name"-sha1
}

echo "创建目录..."
if [ ! -d "$BUILD_DIR" ];then
    mkdir -vp "$BUILD_DIR"
fi

echo "创建压缩文档..."
makepack "$PWD/pack_main" "xmzs-resources"
makepack "$PWD/pack_empty" "empty"

echo "完成!"