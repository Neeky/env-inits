#!/usr/bin/env bash

# 1、下载 Python 安装包
# 2、安装 Python 相关的依赖
# 3、安装 Python
# 4、配置 pip 源

# 变更定义
# Python 安装包的版本号
VERSION=3.12.4
PKGURL="https://www.python.org/ftp/python/${VERSION}/Python-${VERSION}.tgz"
PKGFILE="Python-${VERSION}.tgz"
CWD=`pwd`

# 检查是不是已经安装过了
if test -s "/usr/local/python"; then
    echo "/usr/local/python 已经存在, 不进行重复安装"
    exit
fi

echo "准备安装 Python-${VERSION} 版本" && echo "" && echo ""
echo "CWD=${CWD}"
echo "VERSION=${VERSION}"
echo "PKGURL=${PKGURL}"
echo "PKGFILE=${PKGFILE}"
echo "" && echo ""

# 安装依赖
echo "准备安装依赖包 gcc libffi-devel zlib-devel xz-devel libxml2-devel sqlite-devel ncurses-devel pcre-devel openssl-devel libaio-devel libsqlite3x-devel numactl-devel"
yum -y install gcc libffi-devel zlib-devel xz-devel libxml2-devel sqlite-devel ncurses-devel pcre-devel openssl-devel libaio-devel libsqlite3x-devel numactl-devel >/dev/null


# 下载安装包
echo "准备下载依安装包 Python-${VERSION}.tgz"
if test -f "${PKGFILE}"; then
    echo "安装包文件已经存在，跳过下载"
else
    echo "${PKGURL}"
    wget "${PKGURL}"
fi


# 解压
if test -d "/tmp/Python-${VERSION}"; then 
    echo "/tmp/Python-${VERSION} 已经存在不再解压"
else 
    tar -xvf Python-3.12.4.tgz -C /tmp/
fi


# 编译安装
cd "/tmp/Python-${VERSION}"
if test -d "/usr/local/python-${VERSION}"; then
    echo "目录 /usr/local/python-${VERSION} 存在，看起来对应版本的 Python 已经安装了"
else
    echo "编译安装"
    ./configure --prefix=/usr/local/python-3.12.4 && make -j 4 && make install
fi


# 创建连接
if test -s "/usr/local/python"; then
    echo "/usr/local/python 已经存在 "
else
    echo "创建连接文件 /usr/local/python"
    cd /usr/local/
    ln -s python-3.12.4 python
fi


# 配置 pip 源
export PATH="/usr/local/python-${VERSION}/bin":${PATH}
echo "pip config set global.index-url https://mirrors.cloud.tencent.com/pypi/simple"
pip config set global.index-url https://mirrors.cloud.tencent.com/pypi/simple
