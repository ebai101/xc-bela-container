# xc-bela

Docker image for Bela development and cross-compilation.

```shell
# if the Bela needs to be updated before copying files to the image run these
# they will take a while since they're running on the board
Bela/scripts/update_board.sh
scripts/build_lib.sh

# build the image
docker build --squash --tag ebai101/xc-bela .
```

### Todo

- eliminate one of (or sync) the Bela directories `/sysroot/root/Bela` and `${workspaceRoot}/external/Bela`
- trim size down (currently 1.48 GB)