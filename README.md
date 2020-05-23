# xc-bela

Docker image/VSCode dev container for Bela development and cross-compilation. Uses Clang 10, CMake and Ninja for a fast and modular builds.

## Usage

This repo is set up to run the image as a VSCode development container. It should be able to work with other editors/IDEs with some setup, or even just as a terminal. However, the following instructions assume you're using VSCode.

### Quickstart

Install the [Remote Development](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.vscode-remote-extensionpack) pack if you don't already have it.

Open this folder in VSCode and run the command `Remote-Containers: Reopen in Container` or click the popup when prompted. This will download the image, install a few extensions and attach the editor to the container.

You'll be greeted with an empty workspace. Open an integrated terminal and clone [the main repo](https://github.com/odea-audio/chorale), then open the `code-workspace` file in the repo.

From here, you can configure and build with CMake and Ninja 

### Extensions

The extensions installed by default are:

- [clangd](https://marketplace.visualstudio.com/items?itemName=llvm-vs-code-extensions.vscode-clangd) - much better IDE features for C/C++ than the Microsoft extension
- [Native Debug](https://marketplace.visualstudio.com/items?itemName=webfreak.debug) - support for debugging over SSH
- [CMake Tools](https://marketplace.visualstudio.com/items?itemName=ms-vscode.cmake-tools) - CMake support for building and debugging
- [cmake](https://marketplace.visualstudio.com/items?itemName=twxs.cmake) - syntax highlighting for CMake files

Some others you may want to install locally:

- [DeviceTree](https://marketplace.visualstudio.com/items?itemName=plorefice.devicetree) - syntax highlighting for device tree files
- [PASM Syntax](https://github.com/ebai101/pasm-syntax) - syntax highlighting for PRU assembly

Extensions are stored on a Docker volume, so they will persist through container rebuilds - so you shouldn't need to edit `devcontainer.json` to add extensions, just install them normally. 

### Environment Variables

`.devcontainer/devcontainer.env` contains important environment variables that you should set before building the container:

**BBB_HOSTNAME** - set this to the IP address of your Bela (could be 192.168.6.2, 192.168.7.2, etc)

You can set any other variables you wish in this file; they will all be sourced when the container starts up.

## Building the Image

You don't usually need to build the image - Docker will pull it from Docker Hub automatically when you open the dev container for the first time. However, if you want to make changes that will persist across container boots, you can rebuild the image yourself. ***Note: These instructions are written for macOS/Linux.***

First, make sure your Bela is connected - you'll need to copy some headers and libraries from it and compile the `libbelafull` static library. Open `scripts/build_settings` and change `BBB_HOSTNAME` to the IP address of your connected Bela.

If the Bela needs to be updated (e.g. if the static libraries haven't been compiled), run these commands:

```shell
Bela/scripts/update_board.sh
scripts/build_libs.sh
```

You will only need to do this once, unless you change any of the core library code. Make any changes you wish to the scripts/Dockerfile, then start the build:

```shell
docker build --tag xc-bela:mybuild .
```

Finally, update `.devcontainer/devcontainer.json` to use your custom build:

```json
...
"context": ".",
"image": "xc-bela:mybuild",
"workspaceFolder": "/workspace",
...
```
