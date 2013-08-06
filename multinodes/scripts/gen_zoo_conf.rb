# -*- mode: ruby -*-
# vi: set ft=ruby :
require 'yaml'
require 'erb'
base_dir = File.expand_path(File.join(File.dirname(__FILE__), ".."))
require File.join(base_dir, "lib", "gen_node_infos.rb")

cluster_yml = YAML.load(File.read(File.join(base_dir, "cluster.yml")))
node_infos = gen_node_infos(cluster_yml)
zk_infos = node_infos[:zk]

erb = ERB.new(File.read(File.join(base_dir, "scripts", "conf_templates", "zoo.cfg.erb")))
puts erb.result(binding)

