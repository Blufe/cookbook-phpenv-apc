#
# Cookbook Name:: phpenv-apc
# Recipe:: install
#
# Copyright 2015, bluephoenixlab@gmail.com
#
# All rights reserved - Do Not Redistribute
#

::Chef::Recipe.send(:include, Phpenv::Helpers)
::Chef::Provider.send(:include, Phpenv::Helpers)
::Chef::Resource.send(:include, Phpenv::Helpers)

ruby_block "phpenv-apc::install#set-env-phpenv" do
  block do
    ENV["PHPENV_ROOT"] = node["phpenv"]["root_path"]
    ENV["PATH"] = "#{ENV['PHPENV_ROOT']}/bin:#{ENV['PATH']}"
  end
  not_if { ENV["PATH"].include?(node["phpenv"]["root_path"]) }
end

# http://pecl.php.net/get/APC-#{node["phpenv"]["apc"]["version"]}.tgz
remote_file File.join(node["phpenv"]["apc"]["src_dir"], "#{node["phpenv"]["apc"]["module_name"]}-#{node["phpenv"]["apc"]["version"]}.tgz") do
  source "http://pecl.php.net/get/#{node["phpenv"]["apc"]["module_name"]}-#{node["phpenv"]["apc"]["version"]}.tgz"
  owner  node["phpenv"]["user"]
  group  node["phpenv"]["group"]
  action :create_if_missing
end
bash "compile apc" do
  cwd   File.join(node["phpenv"]['apc']['src_dir'])
  user  node["phpenv"]["user"]
  group node["phpenv"]["group"]
  code <<-EOH
    tar zxvf #{node["phpenv"]["apc"]["module_name"]}-#{node["phpenv"]["apc"]["version"]}.tgz
    cd #{node["phpenv"]["apc"]["module_name"]}-#{node["phpenv"]["apc"]["version"]}
    eval "$(phpenv init -)"
    phpize
    ./configure --enable-#{node["phpenv"]["apc"]["module_name"]} --with-apxs
    make
    make install
  EOH
end
