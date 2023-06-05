group "default" {
  targets = []
}

group "develop" {
  targets = [
    "headless-plugins-dev-full-amd64",
    "headless-plugins-dev-full-arm64",
    "headless-plugins-dev-lite-amd64",
    "headless-plugins-dev-lite-arm64"
  ]
}

group "stable" {
  targets = []
}

target "headless-plugins-dev-full-amd64" {
  dockerfile = "Dockerfile"
  platforms = ["linux/amd64"]
  tags = [
    "headless-plugins:develop-amd64",
    "headless-plugins:develop",
  ]
}

target "headless-plugins-dev-full-arm64" {
  dockerfile = "Dockerfile"
  args = {
    STAGE = "lite",
  }
  platforms = ["linux/arm64"]
  tags = [
    "headless-plugins:develop-arm64",
  ]
}

target "headless-plugins-dev-lite-amd64" {
  dockerfile = "Dockerfile"
  platforms = ["linux/amd64"]
  args = {
    STAGE = "lite",
  }
  tags = [
    "headless-plugins:develop-lite-amd64",
    "headless-plugins:develop-lite",
  ]
}

target "headless-plugins-dev-lite-arm64" {
  dockerfile = "Dockerfile"
  args = {
    STAGE = "lite",
  }
  platforms = ["linux/arm64"]
  tags = [
    "headless-plugins:develop-lite-arm64",
  ]
}
