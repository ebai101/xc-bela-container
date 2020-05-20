#!/bin/bash -e
source build_settings

# install initial packages
apt-get update
apt-get install -y wget gpg apt-utils rsync git

# pre-register ssh key
mkdir ~/.ssh
ssh-keyscan $BBB_ADDRESS >> ~/.ssh/known_hosts

# system includes
rsync -rzLR --safe-links --out-format="   %n" $BBB_HOSTNAME:/usr/lib/arm-linux-gnueabihf sysroot/
rsync -rzLR --safe-links --out-format="   %n" $BBB_HOSTNAME:/usr/lib/gcc/arm-linux-gnueabihf sysroot/
rsync -rzLR --safe-links --out-format="   %n" $BBB_HOSTNAME:/usr/include sysroot/
rsync -rzLR --safe-links --out-format="   %n" $BBB_HOSTNAME:/lib/arm-linux-gnueabihf sysroot/

# xenomai
mkdir -p ./sysroot/usr/xenomai/include
mkdir -p ./sysroot/usr/xenomai/lib
rsync -avz --out-format="   %n" $BBB_HOSTNAME:/usr/xenomai/include ./sysroot/usr/xenomai
rsync -avz --out-format="   %n" $BBB_HOSTNAME:/usr/xenomai/lib ./sysroot/usr/xenomai

# 'missing'
rsync -avz --out-format="   %n" $BBB_HOSTNAME:/usr/lib/libNE10.* ./sysroot/usr/lib
rsync -avz --out-format="   %n" $XC_SSH:/usr/lib/libmathneon.* ./sysroot/usr/lib

# bela
mkdir -p ./sysroot/root/Bela/include
mkdir -p ./sysroot/root/Bela/lib
rsync -avz --out-format="   %n" $BBB_HOSTNAME:/root/Bela/libraries ./sysroot/root/Bela
rsync -avz --out-format="   %n" $BBB_HOSTNAME:/root/Bela/include ./sysroot/root/Bela
rsync -avz --out-format="   %n" $BBB_HOSTNAME:/root/Bela/build/pru/pru_rtaudio_irq_bin.h ./sysroot/root/Bela/include
rsync -avz --out-format="   %n" $BBB_HOSTNAME:/root/Bela/build/pru/pru_rtaudio_bin.h ./sysroot/root/Bela/include
rsync -avz --out-format="   %n" $BBB_HOSTNAME:/root/Bela/lib ./sysroot/root/Bela

# alsa
mkdir -p ./sysroot/usr/include/alsa
rsync -avz --out-format="   %n" $BBB_HOSTNAME:/usr/include/alsa ./sysroot/usr/include

# usr/local
mkdir -p ./sysroot/usr/local/lib
mkdir -p ./sysroot/usr/local/include
rsync -avz --out-format="   %n" $BBB_HOSTNAME:/usr/local/include/prussdrv.h ./sysroot/usr/local/include
rsync -avz --out-format="   %n" $BBB_HOSTNAME:/usr/local/include/seasocks ./sysroot/usr/local/include
rsync -avz --out-format="   %n" $BBB_HOSTNAME:/usr/local/lib/libpd.* ./sysroot/usr/local/lib
rsync -avz --out-format="   %n" $BBB_HOSTNAME:/usr/local/lib/libseasocks.* ./sysroot/usr/local/lib
rsync -avz --out-format="   %n" $BBB_HOSTNAME:/usr/local/lib/libprussdrv.* ./sysroot/usr/local/lib
rsync -avz --out-format="   %n" $BBB_HOSTNAME:/usr/local/include/libpd ./sysroot/usr/local/include
rsync -avz --out-format="   %n" $BBB_HOSTNAME:/usr/local/lib/libpd.so* ./sysroot/usr/local/lib

# add llvm 10 source
echo "deb http://apt.llvm.org/buster/ llvm-toolchain-buster-10 main" >> /etc/apt/sources.list.d/llvm10.list
echo "deb-src http://apt.llvm.org/buster/ llvm-toolchain-buster-10 main" >> /etc/apt/sources.list.d/llvm10.list

# add apt key
wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key | apt-key add -
apt-get update

# install rest of the packages
apt-get install -y libllvm-10-ocaml-dev libllvm10 llvm-10 llvm-10-dev llvm-10-doc llvm-10-examples llvm-10-runtime
apt-get install -y clang-10 clang-tools-10 clang-10-doc libclang-common-10-dev libclang-10-dev libclang1-10 clang-format-10
apt-get install -y binutils-arm-linux-gnueabihf cpp-arm-linux-gnueabihf gcc-arm-linux-gnueabihf
apt-get install -y linux-libc-dev-armhf-cross

echo "Finishing up..."