#!/bin/sh
eval $(bitbake -e multiconfig:qemuriscv64-bullseye-ports:isar-image-base | grep "^DEPLOY_DIR_IMAGE=")
eval $(bitbake -e multiconfig:qemuriscv64-bullseye-ports:isar-image-base | grep "^EXT4_IMAGE_FILE=")
ROOTFS=${DEPLOY_DIR_IMAGE}/${EXT4_IMAGE_FILE}
BBL=${DEPLOY_DIR_IMAGE}/bbl

qemu-system-riscv64 \
   -nographic \
   -machine virt \
   -smp 4 \
   -m 2G \
   -kernel ${BBL} \
   -object rng-random,filename=/dev/urandom,id=rng0 \
   -device virtio-rng-device,rng=rng0 \
   -append "console=ttyS0 ro root=/dev/vda" \
   -device virtio-blk-device,drive=hd0 \
   -drive file=${ROOTFS},format=raw,id=hd0 \
   -device virtio-net-device,netdev=usernet \
   -netdev user,id=usernet,hostfwd=tcp::10000-:22
