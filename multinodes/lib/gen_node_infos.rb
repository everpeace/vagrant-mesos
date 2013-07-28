# -*- mode: ruby -*-
# vi: set ft=ruby :

def gen_node_infos(master_n, master_ipbase, master_mem,
                   slave_n , slave_ipbase,  slave_mem,
                             zk_ipbase,     zk_mem,
                  force_zk)
  master_infos = (1..master_n).map do |i|
                   { :hostname => "master#{i}",
                     :ip => master_ipbase + "#{10+i}",
                     :mem => master_mem }
                 end
  slave_infos = (1..slave_n).map do |i|
                   { :hostname => "slave#{i}",
                     :ip => slave_ipbase + "#{10+i}",
                     :mem => slave_mem }
                 end

  zk_n = master_n > 1 ? 3 : (force_zk ? 1 : 0)
  zk_infos = (1..zk_n).map do |i|
               { :hostname => "zk#{i}",
                 :ip => zk_ipbase + "#{10+i}",
                 :mem => zk_mem }
             end

  return { :master => master_infos, :slave=>slave_infos, :zk=>zk_infos }
end
