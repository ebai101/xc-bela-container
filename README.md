# xc-bela

Docker image for Bela development and cross-compilation.

## Usage

To open a development environment with the container, just open this folder in VSCode and run the command `Remote-Containers: Reopen in Container`. The workspace is mounted as a volume to improve performance, so the workspace will be empty by default. You can `git clone` your code into the container, or use `docker cp` to copy files into the volume.

`.devcontainer/devcontainer.env` contains important environment variables that you should set before building the container:

BBB_HOSTNAME - set this to the IP address of your Bela (could be 192.168.6.2, 192.168.7.2, etc)

## Building the Image

You don't usually need to build the image - Docker will pull it from Docker Hub automatically when you open the container for the first time. However, if you want to make any changes to the base image you can rebuild the container yourself.

First, make sure your Bela is connected - you'll need it to copy headers and libraries from, and possibly to run some build tasks. Open `scripts/build_settings` and make any necessary changes.

If the Bela needs to be updated (e.g. if the static libraries haven't been compiled), run these commands:

```shell
Bela/scripts/update_board.sh
scripts/build_libs.sh
```

Make any changes you wish to the scripts/Dockerfile, then start the build:

```shell
docker build --tag xc-bela:mybuild .
```

You might want to update `.devcontainer/devcontainer.json` to use your custom build as well:

```json
...
"context": ".",
"image": "xc-bela:mybuild",
"workspaceFolder": "/workspace",
...
```

### Todo

- eliminate one of (or sync) the Bela directories `/sysroot/root/Bela` and `${workspaceRoot}/external/Bela`
- trim size down (currently over a gigabyte)