#!/bin/bash

# 森罗万象 一键安装脚本
# 支持系统：CentOS/RHEL 7+, Debian 11+, Ubuntu 18+, Fedora 32+, etc

info() {
    echo -e "\033[32m[SLWX] $*\033[0m"
}

warning() {
    echo -e "\033[33m[SLWX] $*\033[0m"
}

abort() {
    echo -e "\033[31m[SLWX] $*\033[0m"
    exit 1
}

if [[ $EUID -ne 0 ]]; then
    abort "错误：此脚本必须以root权限运行"
fi

OS_ARCH=$(uname -m)
case "$OS_ARCH" in
    x86_64)
    ;;
    *)
    abort "请联系官方获取该CPU架构版本: $OS_ARCH"
    ;;
esac

if [ -f /etc/os-release ]; then
    source /etc/os-release
    OS_NAME=$ID
    OS_VERSION=$VERSION_ID
elif type lsb_release >/dev/null 2>&1; then
    OS_NAME=$(lsb_release -si | tr '[:upper:]' '[:lower:]')
    OS_VERSION=$(lsb_release -sr)
else
    abort "无法检测操作系统"
fi

install_slwx() {
    if [ "$OS_ARCH" = "x86_64" ]; then                
        curl https://download.uusec.com/slwx.tgz -o /tmp/slwx.tgz
    fi

    mkdir -p /opt && tar -zxf /tmp/slwx.tgz -C /opt/ && /opt/slwx/slwx -s install && systemctl start slwx
    if [ $? -ne "0" ]; then
        abort "森罗万象安装失败"
    fi
}

allow_firewall_ports() {
    if [ ! -f "/opt/slwx/.fw" ];then
        echo "" > /opt/slwx/.fw
        if [ $(command -v firewall-cmd) ]; then
            firewall-cmd --permanent --add-port=10203/tcp > /dev/null 2>&1
            firewall-cmd --reload > /dev/null 2>&1
        elif [ $(command -v ufw) ]; then
            for port in 10203; do ufw allow $port/tcp > /dev/null 2>&1; done
            ufw reload > /dev/null 2>&1
        fi
    fi
}

main() {
    info "检测到系统：${OS_NAME} ${OS_VERSION} ${OS_ARCH}"

    if [ ! -f "/opt/slwx/slwx" ]; then
        warning "安装森罗万象..."
        install_slwx
    else
        abort "已安装森罗万象"
    fi

    warning "添加防火墙端口例外..."
    allow_firewall_ports

    info "恭喜你安装成功"
}

main
