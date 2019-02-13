workflow "Build and Publish" {
  on = "push"
  resolves = ["Test lcbot", "Publish lc0", "Publish lc0 CPU"]
}

action "Build lc0" {
  uses = "actions/docker/cli@master"
  args = "build --target lc0 -t gpu ."
}

action "Tag lc0" {
  needs = ["Build lc0"]
  uses = "actions/docker/tag@master"
  args = "gpu vochicong/lc0-docker"
}

action "Test lcbot" {
  needs = ["Build lc0"]
  uses = "actions/docker/cli@master"
  args = "build --target lcbot ."
}

action "Publish Filter" {
  needs = ["Build lc0"]
  uses = "actions/bin/filter@master"
  args = "branch master"
}

action "Login" {
  needs = ["Publish Filter"]
  uses = "actions/docker/login@master"
  secrets = ["DOCKER_USERNAME", "DOCKER_PASSWORD"]
}

action "Publish lc0" {
  needs = ["Login", "Tag lc0"]
  uses = "actions/docker/cli@master"
  args = "push vochicong/lc0-docker"
}

action "Build lc0 CPU" {
  uses = "actions/docker/cli@master"
  args = "build --target lc0 -t vochicong/lc0-docker:cpu cpu"
}

action "Publish lc0 CPU" {
  needs = ["Login", "Build lc0 CPU"]
  uses = "actions/docker/cli@master"
  args = "push vochicong/lc0-docker:cpu"
}
