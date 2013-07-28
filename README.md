Setting up Mesos using Vagrant
===

This contains two vagrant sandbox environment.

* standalone environment
* cluster environment (still buggy.)
  * mesos ships useful [mesos-ec2 scripts](https://github.com/apache/mesos/blob/master/docs/EC2-Scripts.textile). you can try it. 


Prerequisites
----
* VirtualBox: <https://www.virtualbox.org/>
* vagrant 1.2+: <http://www.vagrantup.com/>
* vagrant plugins
    * [vagrant-omnibus](https://github.com/schisamo/vagrant-omnibus)
          `$ vagrant plugin install vagrant-omnibus`
    * [vagrant-berkshelf](https://github.com/RiotGames/vagrant-berkshelf)
          `$ vagrant plugin install vagrant-berkshelf`
    * [vagrant-hosts](https://github.com/adrienthebo/vagrant-hosts)
          `$ vagrant plugin install vagrant-hosts`
    * [vagrant-cachier](https://github.com/fgrehm/vagrant-cachier)(optional)
          `$ vagrant plugin install vagrant-cachier`
 
Standalone Environment
----
### Setup a Mesos Virtual Box
It's so simple! It's time to get a cup of coffee because this may take some time.

    $ cd standalone
    $ vagrant up
    
### Mesos cluster in single node.
log in to the VM and you just need to hit below commands.

1. start a mesos master:

        $ vagrant ssh
        vagrant@mesos$ sudo mesos-master
1. start a mesos slave:

        $ vagrat ssh
        vagrant@mesos$ sudo mesos-slave --master=mesos:5050

If everything went well, you can see mesos web UI on: <http://localhost:5050>

### Mesos cluster managed with zookeeper
if you want to try mesos with zookeeper, which is responsible for managing master processes, you can try belows.

1. start zookeeper:

        $ vagrant ssh
        vagrant@mesos$ cd mesos/build/3rdparty/zookeeper-3.3.4/
        vagrant@mesos$ cp conf/zoo_sample.cfg conf/zoo.cfg
        vagrant@mesos$ sudo bin/zkServer.sh start

1. start mesos master with zookeeper:

        $ vagrant ssh
        vagrant@mesos$ sudo mesos-master --zk=zk://mesos:2181/mesos

1. start mesos slave with master managed with zookeeper:

        $ vagrant ssh
        vagrant@mesos$ sudo mesos-slave --master=zk://mesos:2181/mesos

### Try some example frameworks
please try below by following the [getting started](http://mesos.apache.org/gettingstarted/) document.

    $ vagrant ssh
    vagrant@mesos$ cd mesos/build
    vagrant@mesos$ src/test-framework --master=mesos:5050       # or --master=zk://mesos:2181/mesos
    vagrant@mesos$ src/example/java/test-framework mesos:5050   # or zk://mesos:2181/mesos
    vagrant@mesos$ src/example/python/test-framework mesos:5050 # or zk://mesos:2181/mesos

Multinode environment
----
### How to define cluster configurations
You can edit the top section of `Vagrantfile` in the directory.
default setting is like below.

```
# Cluster configurations
master_n = 1     # number of masters
slave_n  = 1     # number of slaves
force_zk = false # enforce to use zookeeper
                 # even if master_n is 1.

# VM Settings
zk_ipbase     = "192.168.30."
master_ipbase = "192.168.31."
slave_ipbase  = "192.168.32."
master_mem    = "512"          # in MB
slave_mem     = "1024"         # in MB
zk_mem        = "256"          # in MB
```

### Start & Stop Cluster
In multinode environment, `mesos-vagrant`, which is a helper script for controling mesos cluster is provided.

#### Launch a Cluster
This takes several minutes(may be 10 to 20 min.).  It's time for coffee.

```
$ cd multinodes
$ ./mesos-vagrant launch
```
#### Start/Stop a Cluster
```
$ cd multinodes
$ ./mesos-vagrant [start|stop]
```

#### Check a Status of a Cluster
```
$ cd multinodes
$ ./mesos-vagrant status
```

### Destroy a Cluster
this operations delete all VMs consisting mesos cluster.
```
$ cd multinodes
$ ./mesos-vagrant destroy
```

### Usage of `mesos-vagrant`
```
$ cd multinodes
$ ./mesos-vagrant -h
mesos-vagrant: vagrant wrapper helper script for controlling a mesos cluster.
Usage: mesos-vagrant [-h] command

   -h,  --help                       Print this help.

Available commands:
    destroy                          Destroy all VMs
    launch                           Equivalent to up and then start.
    start                            Start mesos cluster.
    stop                             Stop mesos cluser.
    provision                        Equivalent with 'vagrant provision'
    resume                           Equivalent with 'vagrant resume'
    status                           print status of VMs and cluster
    suspend                          Equivalent with 'vagrant suspend'
    up                               Equivalent with 'vagrant up'
```

