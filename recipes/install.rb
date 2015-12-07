#
# Cookbook Name:: docker-redis
# Recipe:: install
#
# Copyright (C) 2014 Daniel Ku
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#

# Cread volumens directory
directory node[:redis][:config_path] do
	recursive true
	action :create
end

# Build the configuration
template "#{node[:redis][:config_path]}/redis.conf" do
	source "redis.conf.erb"
	variables :config => node[:redis][:config]
	action :create
	notifies :restart, "docker_container[redis]", :delayed
end

docker_container 'redis' do
  image node[:redis][:docker_image]
  tag node[:redis][:docker_image_tag]
  container_name 'redis'
  entrypoint 'redis-server'
  command '--port 6379'
  detach true
  port '6379:6379' if node[:redis][:expose_port]
  volumes [
		"#{node[:redis][:config_path]}/redis.conf:/usr/local/etc/redis/redis.conf"
	]
end


