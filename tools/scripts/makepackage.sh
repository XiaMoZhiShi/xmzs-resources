#!/bin/bash
set -e

DISPLAYNAME="打包脚本"
source "$(dirname "$(readlink -f "$0")")/common/common"

createpid

readonly BUILD_DIR="$PWD/build";

function changeDir()
{
    local target="$1"
    log "更改当前目录到$target..."

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

    echo "$option_gen" | tools/packsquash || die 1 "打包时出现问题($?)，配置文件是：${option_gen}"
    sha1sum "$PWD/build/$finalName.zip" | cut -d ' ' -f1 > "$PWD/build/$finalName"-sha1
}

function makedir()
{
    local target="$1"

    log "检查 $1 是否存在..."
    if [ ! -d "$1" ]; then
        log "$1 不存在，将创建此目录"
    fi;
}

log "初始化submodule..."
git submodule update --init --recursive || log LWARN "无法初始化submodule，构建可能会出现问题"

makedir "$BUILD_DIR"

for d in ./src_*; do
    outName="${d/src/pack}"
    makedir "$outName"
done;

for s in tools/scripts/ext_*; do
    log "运行扩展脚本: $s"
    "$s" || die 255 "运行扩展脚本时遇到问题"
done;

for d in pack_* ;do
    log "创建压缩文档: $d"
    makepack "$PWD/$d" || die 255 "创建压缩文档时遇到问题"
done;

log "完成!"