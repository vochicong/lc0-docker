FROM nvidia/cuda:10.0-cudnn7-runtime as lc0base
RUN apt-get update &&\
    apt-get install -y libopenblas-base libprotobuf10 zlib1g-dev \
            ocl-icd-libopencl1 &&\
    apt-get clean all

FROM lc0base as botbase
RUN apt-get update &&\
    apt-get install -y python3 &&\
    apt-get clean all

FROM nvidia/cuda:10.0-cudnn7-devel as builder
RUN apt-get update &&\
    apt-get install -y curl wget supervisor git \
            clang-6.0 libopenblas-dev ninja-build protobuf-compiler libprotobuf-dev \
            python3-pip python3-venv &&\
    apt-get clean all
RUN pip3 install meson

# Download latest lc0 release
RUN curl -s -L https://github.com/LeelaChessZero/lc0/releases/latest |\
    egrep -o '/LeelaChessZero/lc0/archive/v.*.tar.gz' |\
    wget --base=https://github.com/ -O lc0latest.tgz -i - &&\
    tar xfz lc0latest.tgz && rm lc0latest.tgz && mv lc0* /lc0
WORKDIR /lc0
RUN CC=clang-6.0 CXX=clang++-6.0 INSTALL_PREFIX=/lc0 \
    ./build.sh release && ls /lc0/bin
WORKDIR /lc0/bin
RUN curl -s -L https://github.com/LeelaChessZero/lczero-client/releases/latest |\
        egrep -o '/LeelaChessZero/lczero-client/releases/download/v.*/client_linux' |\
        head -n 1 | wget --base=https://github.com/ -i - &&\
    chmod +x client_linux

RUN git clone https://github.com/careless25/lichess-bot.git /lcbot
WORKDIR /lcbot
RUN python3 -m venv .venv &&\
    . .venv/bin/activate &&\
    pip3 install wheel &&\
    pip3 install -r requirements.txt

FROM lc0base as lc0
COPY --from=builder /lc0/bin /lc0/bin
WORKDIR /lc0/bin
CMD ./client_linux --user lc0docker --password lc0docker

FROM botbase as lcbot
COPY --from=builder /lc0/bin /lc0/bin
COPY --from=builder /lcbot /lcbot
WORKDIR /lcbot

FROM lcbot
WORKDIR /lc0/bin
CMD ./client_linux --user lc0docker --password lc0docker
