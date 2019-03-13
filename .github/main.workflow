workflow "Build and Publish" {
  on = "push"
  resolves = ["Test lcbot", "Publish lc0"]
}

action "Build lc0" {
  uses = "actions/docker/cli@master"
  args = "build --target lc0 -t lc0 ."
}

action "Tag lc0" {
  needs = ["Build lc0"]
  uses = "actions/docker/tag@master"
  args = "lc0 vochicong/lc0-docker"
}

action "Test lcbot" {
  needs = ["Build lc0"]
  uses = "actions/docker/cli@master"
  args = "build --target lcbot ."
}

# action "Publish Filter" {
#   needs = ["Build lc0"]
#   uses = "actions/bin/filter@master"
#   args = "branch master"
# }

action "Login" {
  needs = [
    # "Publish Filter",
    "Build lc0",
  ]
  uses = "actions/docker/login@master"
  secrets = ["DOCKER_USERNAME", "DOCKER_PASSWORD"]
}

action "Publish lc0" {
  needs = ["Login", "Tag lc0"]
  uses = "actions/docker/cli@master"
  args = "push vochicong/lc0-docker"
}
