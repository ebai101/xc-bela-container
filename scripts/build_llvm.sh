set -e

URL="https://github.com/llvm/llvm-project/releases/download/llvmorg-10.0.0/clang+llvm-10.0.0-x86_64-linux-gnu-ubuntu-18.04.tar.xz"

echo "Downloading LLVM..."
wget -nv -O "llvm-10.tar.xz" ${URL}
echo "Unzipping LLVM..."
mkdir llvm-10 && tar -xf "llvm-10.tar.xz" -C llvm-10 --strip-components 1
rm "llvm-10.tar.xz"