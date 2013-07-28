# -*- mode: ruby -*-
# vi: set ft=ruby :

def gen_confs(node_infos)
  require 'fileutils'
  master_infos = node_infos[:master]
  slave_infos = node_infos[:slave]
  zk_infos = node_infos[:zk]

  base_dir           = File.expand_path(File.dirname(__FILE__))
  mesos_conf_dir     = File.join(base_dir, "..", "generated", "mesos_conf")
  conf_templates_dir = File.join(base_dir, "..", "scripts"  , "conf_templates")
  zk_conf_dir        = File.join(base_dir, "..", "generated", "zk_conf")

  FileUtils.mkdir_p(mesos_conf_dir)
  File.open(File.join(mesos_conf_dir, "masters"), "w") do |file|
    master_infos.map{|m| m[:hostname]}.each do |hostname|
      file.puts hostname
    end
  end

  File.open(File.join(mesos_conf_dir, "slaves"), "w") do |file|
    slave_infos.map{|s| s[:hostname]}.each do |hostname|
      file.puts hostname
    end
  end

  FileUtils.cp(File.join(conf_templates_dir, "mesos-deploy-env.sh"),
               File.join(mesos_conf_dir, "mesos-deploy-env.sh"))

  require 'erb'
  mesos_master_url = zk_infos.length > 0 ? "zk://"+zk_infos.map{|zk| zk[:hostname]+":2181"}.join(", ")+"/mesos"
                                         : "master1:5050"
  master_infos.each do |master|
    File.open(File.join(mesos_conf_dir, "mesos-#{master[:hostname]}-env.sh"), "w") do |file|
      erb = ERB.new(File.read(File.join(conf_templates_dir, "mesos-master-env.sh.erb")))
      zk_url = mesos_master_url
      master_ip = master[:ip]
      file.puts erb.result(binding)
    end
  end

  File.open(File.join(mesos_conf_dir, "mesos-slave-env.sh"), "w") do |file|
    erb = ERB.new(File.read(File.join(conf_templates_dir, "mesos-slave-env.sh.erb")))
    file.puts erb.result(binding)
  end

  FileUtils.mkdir_p(zk_conf_dir)
  File.open(File.join(zk_conf_dir, "zoo.cfg"), "w") do |file|
    erb = ERB.new(File.read(File.join(conf_templates_dir, "zoo.cfg.erb")))
    file.puts erb.result(binding)
  end

end
