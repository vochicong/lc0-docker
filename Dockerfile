FROM nvidia/cuda:10.0-cudnn7-devel

RUN apt-get update &&\
    apt-get install -y curl wget supervisor git \
            clang-6.0 libopenblas-dev ninja-build protobuf-compiler libprotobuf-dev python3-pip &&\
    apt-get clean all
RUN pip3 install meson

RUN git clone -b master --recurse-submodules https://github.com/LeelaChessZero/lc0.git /lc0
WORKDIR /lc0
RUN CC=clang-6.0 CXX=clang++-6.0 INSTALL_PREFIX=/lc0 \
    ./build.sh release && ls /lc0/bin
WORKDIR /lc0/bin
RUN curl -s -L https://github.com/LeelaChessZero/lczero-client/releases/latest |\
        egrep -o '/LeelaChessZero/lczero-client/releases/download/v.*/client_linux' |\
        head -n 1 | wget --base=https://github.com/ -i - &&\
    chmod +x client_linux

CMD ./client_linux --user lc0docker --password lc0docker

RUN git clone https://github.com/careless25/lichess-bot.git /lcbot
WORKDIR /lcbot
RUN pip3 install virtualenv &&\
    virtualenv .venv -p python3 &&\
    . .venv/bin/activate &&\
    pip3 install -r requirements.txt
