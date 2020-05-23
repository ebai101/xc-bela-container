#!/bin/bash -e
source build_settings
BBB_ADDRESS=root@$BBB_HOSTNAME

grep 'docker\|lxc' /proc/1/cgroup > /dev/null 2>&1 || {
    echo This script should only be called in a container. Run build.sh on the host
    exit 1
}

# pre-register ssh key
mkdir ~/.ssh
ssh-keyscan $BBB_HOSTNAME >> ~/.ssh/known_hosts

# system includes
rsync -rzLR --safe-links --out-format="   %n" $BBB_ADDRESS:/usr/lib/arm-linux-gnueabihf sysroot/
rsync -rzLR --safe-links --out-format="   %n" $BBB_ADDRESS:/usr/lib/gcc/arm-linux-gnueabihf sysroot/
rsync -rzLR --safe-links --out-format="   %n" $BBB_ADDRESS:/usr/include sysroot/
rsync -rzLR --safe-links --out-format="   %n" $BBB_ADDRESS:/lib/arm-linux-gnueabihf sysroot/

# xenomai
mkdir -p ./sysroot/usr/xenomai/include
mkdir -p ./sysroot/usr/xenomai/lib
rsync -avz --out-format="   %n" $BBB_ADDRESS:/usr/xenomai/include ./sysroot/usr/xenomai
rsync -avz --out-format="   %n" $BBB_ADDRESS:/usr/xenomai/lib ./sysroot/usr/xenomai

# 'missing'
rsync -avz --out-format="   %n" $BBB_ADDRESS:/usr/lib/libNE10.* ./sysroot/usr/lib
rsync -avz --out-format="   %n" $BBB_ADDRESS:/usr/lib/libmathneon.* ./sysroot/usr/lib

# bela
mkdir -p ./sysroot/root/Bela/include
mkdir -p ./sysroot/root/Bela/lib
rsync -avz --out-format="   %n" $BBB_ADDRESS:/root/Bela/libraries ./sysroot/root/Bela
rsync -avz --out-format="   %n" $BBB_ADDRESS:/root/Bela/include ./sysroot/root/Bela
rsync -avz --out-format="   %n" $BBB_ADDRESS:/root/Bela/build/pru/pru_rtaudio_irq_bin.h ./sysroot/root/Bela/include
rsync -avz --out-format="   %n" $BBB_ADDRESS:/root/Bela/build/pru/pru_rtaudio_bin.h ./sysroot/root/Bela/include
rsync -avz --out-format="   %n" $BBB_ADDRESS:/root/Bela/lib ./sysroot/root/Bela

# alsa
mkdir -p ./sysroot/usr/include/alsa
rsync -avz --out-format="   %n" $BBB_ADDRESS:/usr/include/alsa ./sysroot/usr/include

# usr/local
mkdir -p ./sysroot/usr/local/lib
mkdir -p ./sysroot/usr/local/include
rsync -avz --out-format="   %n" $BBB_ADDRESS:/usr/local/include/prussdrv.h ./sysroot/usr/local/include
rsync -avz --out-format="   %n" $BBB_ADDRESS:/usr/local/include/seasocks ./sysroot/usr/local/include
rsync -avz --out-format="   %n" $BBB_ADDRESS:/usr/local/lib/libpd.* ./sysroot/usr/local/lib
rsync -avz --out-format="   %n" $BBB_ADDRESS:/usr/local/lib/libseasocks.* ./sysroot/usr/local/lib
rsync -avz --out-format="   %n" $BBB_ADDRESS:/usr/local/lib/libprussdrv.* ./sysroot/usr/local/lib
rsync -avz --out-format="   %n" $BBB_ADDRESS:/usr/local/include/libpd ./sysroot/usr/local/include
rsync -avz --out-format="   %n" $BBB_ADDRESS:/usr/local/lib/libpd.so* ./sysroot/usr/local/lib

echo "Finishing up..."