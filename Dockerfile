FROM debian:buster
ENV DEBIAN_FRONTEND noninteractive

COPY scripts/build_bela.sh \
	scripts/build_packages.sh \
	scripts/build_settings \
	./

RUN ./build_packages.sh && rm build_packages.sh
RUN ./build_bela.sh && rm build_bela.sh && rm build_settings

ENV CC /usr/bin/clang-10
ENV CXX /usr/bin/clang++-10
