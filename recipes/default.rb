#
# Cookbook Name:: phpenv-apc
# Recipe:: default
#
# Copyright 2015, higashi.ryohei@nifty.co.jp
#
# All rights reserved - Do Not Redistribute
#

include_recipe "module::install_apc"
include_recipe "module::configure_apc"
