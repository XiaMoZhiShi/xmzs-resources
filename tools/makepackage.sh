#!/bin/bash
set -e

readonly BUILD_DIR="$PWD/build";

readonly PACKSQUASH_OPTIONS="
pack_directory = \"$PWD\"
output_file_path = \"$PWD/build/xmzs-resources.zip\"

#生成zip文件后就不要再允许以其他的方式更改压缩文档
zip_spec_conformance_level = \"disregard\"
size_increasing_zip_obfuscation = true
"

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
echo "$PACKSQUASH_OPTIONS" | tools/packsquash

echo "生成sha1..."
changeDir "$BUILD_DIR"
sha1sum xmzs-resources.zip | cut -d ' ' -f1 > xmzs-resources-sha1

echo "完成!"