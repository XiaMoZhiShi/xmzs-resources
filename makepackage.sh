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

changeDir "$BUILD_DIR"

echo "创建压缩文档..."
zip -9 xmzs-resources.zip ../assets/**/* 
zip -d xmzs-resources.zip "*.xcf"