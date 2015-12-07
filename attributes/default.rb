default[:redis][:master] = "master"
default[:redis][:docker_image] = "redis"
default[:redis][:docker_image_tag] = "latest"
default[:redis][:expose_port] = true
default[:redis][:config_path] = "/etc/redis"

default[:redis][:config]