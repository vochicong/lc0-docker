FROM nvidia/cuda:10.0-cudnn7-devel

RUN apt-get update &&\
    apt-get install -y curl wget supervisor git &&\
        clang-6.0 ninja-build protobuf-compiler libprotobuf-dev python3-pip &&\
    apt-get clean all
RUN pip3 install meson

RUN git clone -b master --recurse-submodules https://github.com/LeelaChessZero/lc0.git &&\
    cd lc0 && ./build.sh && mkdir -p /lc0 &&\
    cp build/release/lc0 /lc0 && cd /lc0 &&\
    curl -s -L https://github.com/LeelaChessZero/lczero-client/releases/latest |\
        egrep -o '/LeelaChessZero/lczero-client/releases/download/v.*/client_linux' |\
        head -n 1 | wget --base=https://github.com/ -i - &&\
    chmod +x client_linux

WORKDIR /lc0
