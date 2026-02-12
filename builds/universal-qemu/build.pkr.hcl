build {
  // Make sure to name your builds so that you can selectively run them one at
  // a time.
  name = "step1"

  source "source.docker.example" {
    image = "ubuntu"
  }

  provisioner "shell" {
    inline = ["echo example provisioner"]
  }
  provisioner "shell" {
    inline = ["echo another example provisioner"]
  }
  provisioner "shell" {
    inline = ["echo a third example provisioner"]
  }

  // Make sure that the output from your build can be used in the next build.
  // In this example, we're tagging the Docker image so that the step-2
  // builder can find it without us having to track it down in a manifest.
  post-processor "docker-tag" {
    repository = "ubuntu"
    tag = ["step-1-output"]
  }
}

build {
    name = "step2"

    source "source.docker.example" {
      // This is the tagged artifact from the stage 1 build. You can retrieve
      // this from a manifest file and setting it as a variable on the command
      // line, or by making sure you define and know the output of the build,
      // if it's something you can define like an output name or directory.
      image = "ubuntu:step-1-output"
      // disable the pull if your image tag only exists locally
      pull = false
    }

    provisioner "shell" {
      inline = ["echo another provision!"]
    }
}
