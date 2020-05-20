# chorale-image

Docker image for chorale dev environment.

```shell
# if the Bela needs to be updated before copying files to the image run these
# they will take a while since they're running on the board
Bela/scripts/update_board.sh
./makelib.sh

# build the image
docker build --tag odea_bela .
```