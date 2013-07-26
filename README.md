Setting up Mesos using Vagrant
===

This contains two vagrant sandbox environment.

* standalone environment
* cluster environment (not yet.)


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
