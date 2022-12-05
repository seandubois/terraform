terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 2.12.0"
    }
  }
}

provider "docker" {}

resource "docker_image" "nodered_image" {
  name = "nodered/node-red:latest"
}

resource "random_string" "random" {
  count = 2
  length = 4
  special = false
  upper = false
}


resource "docker_container" "nodered_container" {
  count = 2
  name  = join("-",["nodered", random_string.random[count.index].result])
  image = docker_image.nodered_image.latest
  ports {
    internal = 1880
    # external = 1880
  }
}
  
output "container-name" {
  value = docker_container.nodered_container[*].name
  description = "the name of the container"
}

output "IP-Address" {
  value = [for i in docker_container.nodered_container[*]: join(";", [i.ip_address],i.ports[*]["external"])]
  description = "the IP addresss and external port of the container"
}
  
