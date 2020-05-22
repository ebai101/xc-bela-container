#!/bin/bash -e
grep 'docker\|lxc' /proc/1/cgroup > /dev/null 2>&1 || {
    echo This script should only be called in a container. Run build.sh on the host
    exit 1
}

apt-get update
apt-get install -y wget gpg apt-utils #apt-transport-https ca-certificates

echo "deb http://apt.llvm.org/stretch/ llvm-toolchain-stretch-10 main" >> /etc/apt/sources.list.d/llvm10.list
echo "deb http://http.us.debian.org/debian/ stretch main contrib non-free" >> /etc/apt/sources.list.d/stretch.list

wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key | apt-key add -
apt-get update

apt-get install --no-install-recommends -y \
    clang-10 \
	clangd-10 \
	ninja-build \
	coreutils \
	linux-libc-dev-armhf-cross \
	cpp-6-arm-linux-gnueabihf \
	gcc-6-arm-linux-gnueabihf \
	binutils-arm-linux-gnueabihf \
	build-essential \
	rsync \
	ssh \
	cmake \
	git
rm -rf /var/lib/apt/lists/*

echo "Finishing up..."