workflow "Build and Publish" {
  on = "push"
  resolves = ["Publish"]
}

action "Build" {
  uses = "actions/docker/cli@master"
  args = "build -t vochicong/lc0-nvidia-docker ."
}

action "Publish Filter" {
  needs = ["Build"]
  uses = "actions/bin/filter@master"
  args = "branch master"
}

action "Login" {
  needs = ["Publish Filter"]
  uses = "actions/docker/login@master"
  secrets = ["DOCKER_USERNAME", "DOCKER_PASSWORD"]
}

action "Publish" {
  needs = ["Login", "Build"]
  uses = "actions/docker/cli@master"
  args = "push vochicong/lc0-nvidia-docker"
}
