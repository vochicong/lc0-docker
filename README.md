Let's run [lc0](https://github.com/LeelaChessZero/lc0)
under [NVIDIA docker](https://github.com/NVIDIA/nvidia-docker).

# Run it

To download and run the prebuilt Docker image

    docker run --runtime nvidia --rm -it vochicong/lc0-nvidia-docker

otherwise, clone this repository then build and run by

    docker-compose up --build lc0

# Requirements

- [nvidia-docker](https://github.com/NVIDIA/nvidia-docker)
- [docker-compose >= 1.23.2](https://github.com/docker/compose/releases)
