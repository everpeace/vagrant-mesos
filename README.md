Setting up Mesos using Vagrant
===

This contains two vagrant sandbox environment.

* standalone environment
* multi nodes cluster environment
  * If you prefer to EC2 environment, mesos also ships useful [mesos-ec2 scripts](https://github.com/apache/mesos/blob/master/docs/EC2-Scripts.textile). you can try this also.

The setup is provided by mesos chef cookbook.  Please see [everpeace/cookbook-mesos](http://github.com/everpeace/cookbook-mesos).

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
just hit below command.

        $ vagrant ssh -c 'mesos-start-cluster.sh'

If everything went well, you can see mesos web UI on: <http://localhost:5050>

### Mesos cluster managed with zookeeper
if you want to try mesos with zookeeper, which is responsible for managing master processes, you can try belows.

1. change `chef.json[:mesos]` in `Vagrantfile` to

        :mesos => {
          :cluster_name => "MyCluster",
          :master_ips => ["localhost"],
          :slave_ips  => ["localhost"],
          :master => {
            :zk => "zk://localhost:2181/mesos"
          },
          :slave =>{
            :master_url => "zk://localhost:2181/mesos",
          }
        }

1. provision VM again:

        $ vagrant provision

2. start zookeeper:

        $ vagrant ssh
        vagrant@mesos$ cd mesos/build/3rdparty/zookeeper-3.3.4/
        vagrant@mesos$ cp conf/zoo_sample.cfg conf/zoo.cfg
        vagrant@mesos$ sudo bin/zkServer.sh start

1. start mesos cluster with zookeeper managed master:

        $ vagrant ssh -c 'mesos-start-cluster.sh'

### Try some example frameworks
please try below by following the [getting started](http://mesos.apache.org/gettingstarted/) document.

    $ vagrant ssh
    vagrant@mesos$ cd /home/vagrant/mesos/build
    vagrant@mesos$ sudo make check
    vagrant@mesos$ src/test-framework --master=mesos:5050       # or --master=zk://mesos:2181/mesos
    vagrant@mesos$ src/examples/java/test-framework mesos:5050   # or zk://mesos:2181/mesos
    vagrant@mesos$ src/examples/python/test-framework mesos:5050 # or zk://mesos:2181/mesos

Multinode environment
----
### How to define cluster configurations
Cluster configuration is defined at `cluster.yml`.
You can edit the file to congigure cluster configurations.

```
# Cluster configurations
master_n: 1           # hostname will be master1,master2,…
slave_n : 2           # hostname will be slave1,slave2,…
force_zk: false       # force to create zookeeper servers(zk1,zk2,…)
                      # even if master_n is 1.

master_mem: 512
slave_mem : 1024
zk_mem    : 256

master_ipbase: "192.168.31."
slave_ipbase : "192.168.32."
zk_ipbase    : "192.168.33."
```

### Start & Stop Cluster
In multinode environment, `vagrant-mesos`, which is a vagrant wrapper script to help controling mesos cluster, is provided.

#### Launch a Cluster
This takes several minutes(may be 10 to 20 min.).  It's time for coffee.

```
$ cd multinodes
$ ./vagrant-mesos launch
```

#### Start/Stop a Cluster
```
$ cd multinodes
$ ./vagrant-mesos [start|stop]
```
#### Connect to Mesos Web UI
mesos master listen on port 5050 on `192.168.31.??`(virtual private IP). So, by normal virtual box NAT setting, host os can't connect to mesos master. To connect mesos master, you can use ssh port forwarding like this.

```
$ vagrant ssh master1 -- -L15050:master1:5050
```
Then, you can connect mesos web ui on <http://localhost:15050>

#### Check a Status of a Cluster
```
$ cd multinodes
$ ./vagrant-mesos status
```

#### Destroy a Cluster
this operations delete all VMs consisting mesos cluster.

```
$ cd multinodes
$ ./vagrant-mesos destroy
```


### Usage of `vagrant-mesos`
```
$ cd multinodes
$ ./vagrant-mesos -h
vagrant-mesos: vagrant wrapper helper script for controlling a mesos cluster.
Usage: vagrant-mesos [-h] command

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

