# download LLVM
FROM alpine:latest as llvm_download
WORKDIR /root/
RUN apk --no-cache add \
	wget \
	gnupg
COPY scripts/build_llvm.sh .
RUN ./build_llvm.sh

# copy files
FROM alpine:latest
WORKDIR /root/
ENV DEBIAN_FRONTEND noninteractive
RUN apk --no-cache add \
	bash \
    rsync \
    git \
    openssh

COPY --from=llvm_download /root/llvm-10/ /usr/local/
COPY scripts/build_bela.sh scripts/build_settings ./

RUN /usr/local/bin/clang --version
RUN ./build_bela.sh && rm ./build_bela.sh

ENV CXX=/usr/local/bin/clang++
ENV CC=/usr/local/bin/clang