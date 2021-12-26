#!/bin/bash
set -e

readonly BUILD_DIR="$PWD/build";

function changeDir()
{
    local target="$1"
    echo "更改当前目录到$target..."

    cd "$target"
}

echo "创建目录..."
if [ ! -d "$BUILD_DIR" ];then
    mkdir -vp "$BUILD_DIR"
fi

echo "创建压缩文档..."
zip -9 -r xmzs-resources.zip ./assets pack*
zip -d xmzs-resources.zip "*.xcf"

echo "移动文档..."
mv xmzs-resources.zip build

echo "完成!"