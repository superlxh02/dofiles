FROM ubuntu:24.04 AS builder

ARG DEBIAN_FRONTEND=noninteractive
ARG VSOMEIP_VERSION=3.5.4
ARG COMMONAPI_VERSION=3.2.4
ARG FAST_DDS_VERSION=v3.6.2
ARG CYCLONEDDS_VERSION=11.0.1
ARG CYCLONEDDS_CXX_VERSION=11.0.1
ARG COMMONAPI_TOOLS_VERSION=3.2.15
ARG TARGETARCH

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        build-essential ca-certificates clang cmake curl git libasio-dev \
        libboost-filesystem-dev libboost-log-dev libboost-system-dev \
        libboost-thread-dev libfoonathan-memory-dev libssl-dev libtinyxml2-dev \
        libyaml-dev ninja-build \
        pkg-config unzip \
    && rm -rf /var/lib/apt/lists/*

RUN git clone --branch "${VSOMEIP_VERSION}" --depth 1 \
        https://github.com/COVESA/vsomeip.git /tmp/vsomeip \
    && cmake -S /tmp/vsomeip -B /tmp/vsomeip/build -G Ninja \
        -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_INSTALL_PREFIX=/opt/automotive \
        -DENABLE_SIGNAL_HANDLING=ON \
        -DENABLE_TESTS=OFF \
        -DBUILD_TESTING=OFF \
    && cmake --build /tmp/vsomeip/build --parallel \
    && cmake --install /tmp/vsomeip/build

# CommonAPI 3.2.4 uses std::string without including <string>; GCC 13 no
# longer supplies that declaration transitively.
RUN git clone --branch "${COMMONAPI_VERSION}" --depth 1 \
        https://github.com/COVESA/capicxx-core-runtime.git /tmp/commonapi-core \
    && sed -i '/#include <memory>/a #include <string>' \
        /tmp/commonapi-core/include/CommonAPI/Types.hpp \
    && cmake -S /tmp/commonapi-core -B /tmp/commonapi-core/build -G Ninja \
        -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_INSTALL_PREFIX=/opt/automotive \
        -DBUILD_TESTING=OFF \
    && cmake --build /tmp/commonapi-core/build --parallel \
    && cmake --install /tmp/commonapi-core/build

RUN git clone --branch "${COMMONAPI_VERSION}" --depth 1 \
        https://github.com/COVESA/capicxx-someip-runtime.git /tmp/commonapi-someip \
    && cmake -S /tmp/commonapi-someip -B /tmp/commonapi-someip/build -G Ninja \
        -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_INSTALL_PREFIX=/opt/automotive \
        -DCMAKE_PREFIX_PATH=/opt/automotive \
        -DUSE_INSTALLED_COMMONAPI=ON \
        -DBUILD_TESTING=OFF \
    && cmake --build /tmp/commonapi-someip/build --parallel \
    && cmake --install /tmp/commonapi-someip/build

RUN git clone --branch "${FAST_DDS_VERSION}" --depth 1 --recurse-submodules --shallow-submodules \
        https://github.com/eProsima/Fast-DDS.git /tmp/fastdds \
    && cmake -S /tmp/fastdds -B /tmp/fastdds/build -G Ninja \
        -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_INSTALL_PREFIX=/opt/automotive \
        -DTHIRDPARTY=ON \
        -DBUILD_SHARED_LIBS=ON \
        -DBUILD_TESTING=OFF \
        -DCOMPILE_EXAMPLES=OFF \
    && cmake --build /tmp/fastdds/build --parallel \
    && cmake --install /tmp/fastdds/build

RUN git clone --branch "${CYCLONEDDS_VERSION}" --depth 1 \
        https://github.com/eclipse-cyclonedds/cyclonedds.git /tmp/cyclonedds \
    && cmake -S /tmp/cyclonedds -B /tmp/cyclonedds/build -G Ninja \
        -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_INSTALL_PREFIX=/opt/automotive \
        -DBUILD_EXAMPLES=OFF \
        -DBUILD_TESTING=OFF \
        -DENABLE_SSL=ON \
    && cmake --build /tmp/cyclonedds/build --parallel \
    && cmake --install /tmp/cyclonedds/build

RUN git clone --branch "${CYCLONEDDS_CXX_VERSION}" --depth 1 \
        https://github.com/eclipse-cyclonedds/cyclonedds-cxx.git /tmp/cyclonedds-cxx \
    && cmake -S /tmp/cyclonedds-cxx -B /tmp/cyclonedds-cxx/build -G Ninja \
        -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_INSTALL_PREFIX=/opt/automotive \
        -DCMAKE_PREFIX_PATH=/opt/automotive \
        -DBUILD_EXAMPLES=OFF \
        -DBUILD_TESTING=OFF \
    && cmake --build /tmp/cyclonedds-cxx/build --parallel \
    && cmake --install /tmp/cyclonedds-cxx/build

# COVESA only publishes the CommonAPI code generators as Linux x86-64 binaries.
# Runtime libraries remain multi-architecture; generators are included on amd64.
RUN set -eux; \
    mkdir -p /opt/commonapi-generators/core /opt/commonapi-generators/someip; \
    if [ "${TARGETARCH:-amd64}" = "amd64" ]; then \
        curl -fsSL "https://github.com/COVESA/capicxx-core-tools/releases/download/${COMMONAPI_TOOLS_VERSION}/commonapi_core_generator.zip" -o /tmp/core-generator.zip; \
        curl -fsSL "https://github.com/COVESA/capicxx-someip-tools/releases/download/${COMMONAPI_TOOLS_VERSION}/commonapi_someip_generator.zip" -o /tmp/someip-generator.zip; \
        unzip -q /tmp/core-generator.zip -d /opt/commonapi-generators/core; \
        unzip -q /tmp/someip-generator.zip -d /opt/commonapi-generators/someip; \
        find /opt/commonapi-generators -type f -name '*linux*x86_64*' -exec chmod +x {} +; \
    fi

FROM ubuntu:24.04

LABEL org.opencontainers.image.title="automotive-communication-cpp" \
      org.opencontainers.image.description="C++ SOME/IP, CommonAPI, Fast DDS and Cyclone DDS development environment"

ENV DEBIAN_FRONTEND=noninteractive \
    CMAKE_PREFIX_PATH=/opt/automotive \
    PKG_CONFIG_PATH=/opt/automotive/lib/pkgconfig:/opt/automotive/lib64/pkgconfig \
    LD_LIBRARY_PATH=/opt/automotive/lib:/opt/automotive/lib64 \
    PATH=/opt/automotive/bin:/opt/commonapi-generators/core:/opt/commonapi-generators/someip:${PATH}

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        build-essential ca-certificates clang clang-format clangd cmake gdb git \
        iproute2 iputils-ping libasio-dev libboost-filesystem-dev \
        libboost-log-dev libboost-system-dev libboost-thread-dev \
        libfoonathan-memory-dev libssl-dev libtinyxml2-dev libyaml-dev \
        ninja-build pkg-config tcpdump \
    && rm -rf /var/lib/apt/lists/* \
    && command -v clangd \
    && command -v clang-format

COPY --from=builder /opt/automotive /opt/automotive
COPY --from=builder /opt/commonapi-generators /opt/commonapi-generators

RUN printf '%s\n' /opt/automotive/lib /opt/automotive/lib64 \
        > /etc/ld.so.conf.d/automotive.conf \
    && ldconfig

WORKDIR /workspace
CMD ["/bin/bash"]
