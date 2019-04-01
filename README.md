Let's run latest releases of
[lc0](https://github.com/LeelaChessZero/lc0),
[lczero-client](https://github.com/LeelaChessZero/lczero-client)
and [lichess-bot](https://github.com/careless25/lichess-bot)
under [NVIDIA docker](https://github.com/NVIDIA/nvidia-docker).

# Run Lc0 self-play training games

To download and run the [prebuilt Docker image](https://hub.docker.com/r/vochicong/lc0-docker)

    docker run --runtime nvidia --rm -it vochicong/lc0-docker

otherwise, clone this repository then run

    docker-compose up lc0


## Kubernetes

See [k8s.yaml](k8s.yaml) for a sample configuration.

## Version

The docker image is tagged by [lc0 release version](https://github.com/LeelaChessZero/lc0/releases),
see
[.github/main.workflow](.github/main.workflow),
[k8s.yaml](k8s.yaml)
and
[docker-compose.yml](docker-compose.yml).

# Run Lc0 with lichess-bot

- Clone this repository, `cd lc0-nvdia-docker`
- Download and put syzygy tablebases into `data/syzygy`
- Download and put networks (weights) into `data/networks`
- Edit lc0.config and lcbot-config.yml to your preference
- Put your `LICHESS_API_TOKEN` in file `.env` (NEVER git commit this file)

Run

    docker-compose up lcbot

# Requirements

- [Docker](https://docs.docker.com/install/)
- [nvidia-docker](https://github.com/NVIDIA/nvidia-docker)
- [docker-compose >= 1.23.2](https://github.com/docker/compose/releases)
