# xc-bela

Docker image/VSCode environment for [Bela](https://bela.io/) development and cross-compilation. Uses Clang 10, CMake and Ninja for a fast and modular builds.

By containerizing the cross-compilation toolchain, Bela code can be written and compiled on any host OS that can run Docker, and is compiled much faster and with more flexibility than in the Bela IDE. The VSCode environment is also set up for running GDB over SSH, allowing you to debug your Bela programs in the editor.

## Usage

This repo is set up to run the image as a VSCode development container. It should be able to work with other editors/IDEs with some setup, or even just as a terminal. However, the following instructions assume you're using VSCode.

### Quickstart

Install [Docker](https://docs.docker.com/get-docker/) and the [Remote Development](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.vscode-remote-extensionpack) extensions, if you haven't already. Clone the repo to your machine:

```shell
git clone --recurse-submodules https://github.com/ebai101/xc-bela.git
```

Open the repo folder in VSCode and run the command `Remote-Containers: Reopen in Container`  or click the popup when prompted. This will download the image, install a few extensions and attach the editor to the container.

The workspace is stored as a Docker volume to improve disk performance, so it will be empty by default. There's a template repo to get you running quickly, so open an integrated terminal in VSCode (the command is `Terminal: Create New Integrated Terminal`) and clone the template repo:

```shell
git clone --recurse-submodules https://github.com/ebai101/xc-bela-bootstrap
```

The workspace will contain a workspace file called `xc-bela-boostrap.code-workspace`, click on that and choose "Open Workspace." The window will reload and CMake should automatically reconfigure the project. (If it shows an error that says "error: unknown target CPU 'armv7-a'", that's just a bug in the script - run the configuration again and it should work.)

You can use the CMake extension to configure and build now, or do it from the terminal:

```shell
mkdir build # if it doesn't exist already
cd build
cmake ../
cmake --build .
```

After a successful build, the binary (in `build/bin`) will be copied via `scp` to the attached Bela at the IP address `BBB_HOSTNAME` (as specified in your env file.)

### Extensions

The extensions installed by default are:

- [clangd](https://marketplace.visualstudio.com/items?itemName=llvm-vs-code-extensions.vscode-clangd) - much better IDE features for C/C++ than the Microsoft extension
- [Native Debug](https://marketplace.visualstudio.com/items?itemName=webfreak.debug) - support for debugging over SSH
- [CMake Tools](https://marketplace.visualstudio.com/items?itemName=ms-vscode.cmake-tools) - CMake support for building and debugging
- [cmake](https://marketplace.visualstudio.com/items?itemName=twxs.cmake) - syntax highlighting for CMake files

Some others you may want to install locally:

- [DeviceTree](https://marketplace.visualstudio.com/items?itemName=plorefice.devicetree) - syntax highlighting for device tree files
- [PASM Syntax](https://github.com/ebai101/pasm-syntax) - syntax highlighting for PRU assembly
- [Docker](https://marketplace.visualstudio.com/items?itemName=ms-azuretools.vscode-docker) - helpful for managing containers in general, also provides syntax highlighting for Dockerfiles

Extensions are stored on a Docker volume, so they will persist through container rebuilds - so you shouldn't need to edit `devcontainer.json` to add extensions, just install them normally. 

### Environment Variables

`.devcontainer/devcontainer.env` contains important environment variables that you should set before building the container:

- **BBB_HOSTNAME** - set this to the IP address of your Bela (could be 192.168.6.2, 192.168.7.2, etc)
- there will be others I imagine

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

## Contributing

I am developing/testing on macOS, so if any Windows/Linux users have issues and/or fixes for issues on their platform, I'd love to hear them. I'm also open to any methods to get the image size down (it's currently around 1.5 GB!) and anyone willing to improve the CMake setup, as I am still a CMake noob.

The Bela submodule in the repo is currently my personal fork; it has been modified (based on [this PR](https://github.com/BelaPlatform/Bela/pull/626)) to build a single static library containing all Bela object files. Once [this commit](https://github.com/BelaPlatform/Bela/commit/74eb2a59738e16ae3057e3978b115bbbcf030881) allowing custom Makefile hooks is merged into the master, Makefile, we can probably move back to the base repo.

## Credits

All credit for the Bela code goes to Bela and Augmented Instruments Ltd. As per the license terms, this project is also licensed under the LGPLv3.

The cross-compiler setup is based on/inspired by TheTechnoBear's [xcBela](https://github.com/TheTechnobear/xcBela). Initially I was working on this as a fork of his repo - many thanks to him for laying the groundwork.

Also of note is Andrew Capon's [OSXBelaCrossCompiler](https://github.com/AndrewCapon/OSXBelaCrossCompiler) and the related [Bela Wiki](https://github.com/BelaPlatform/Bela/wiki/Compiling-Bela-projects-in-Eclipse) page for Eclipse.

