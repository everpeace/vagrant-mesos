# vagrant-mesos [![Gitter](https://badges.gitter.im/Join Chat.svg)](https://gitter.im/jonasrosland/vagrant-mesos?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

This is a fork of [everpeace/vagrant-mesos](https://github.com/everpeace/vagrant-mesos), adding updated versions of Mesos and Marathon, and also adding new functionality with [REX-Ray](https://github.com/emccode/rexray) and [DVDI](https://github.com/emccode/mesos-module-dvdi).

Spin up your [Mesos](http://mesos.apache.org) cluster with [Vagrant](http://www.vagrantup.com)! (Only AWS is supported currently.)

This spins up Mesos 0.23.0 cluster and also spins up a framework server node in which [Marathon](https://github.com/mesosphere/marathon) (0.11.1) and [Chronos](http://github.com/mesos/chronos) (2.1.0) are running.  This means you can build your own __Mesos+Marathon+Chronos+Docker__ PaaS with `vagrant up --provider=aws`!  Marathon works as distributed `init.d` and Chronos works as distributed `cron`!

To deploy *Docker* containers, refer to the [Marathon documentation](https://mesosphere.github.io/marathon/docs/native-docker.html) and look at the [examples](examples) included in this repo.

* Using Amazon EC2
	* [Mesos Standalone on EC2](#mesos-standalone-on-ec2)
	* [Mesos Cluster on EC2 (VPC)](#mesos-cluster-on-ec2)

The mesos installation is powered by Mesos chef cookbook.  Please see [everpeace/cookbook-mesos](http://github.com/everpeace/cookbook-mesos).

Base boxes used in `Vagrantfile`s are Mesos pre-installed boxes, [everpeace/mesos](https://vagrantcloud.com/everpeace/boxes/mesos) shared on Vagrant Cloud.

Prerequisites
----
* vagrant 1.6.5+: <http://www.vagrantup.com/>
* vagrant plugins
    * [vagrant-omnibus](https://github.com/schisamo/vagrant-omnibus)
          `$ vagrant plugin install vagrant-omnibus`
    * [vagrant-berkshelf](https://github.com/berkshelf/vagrant-berkshelf) (>=4.0.0)
          `$ vagrant plugin install vagrant-berkshelf`
		* To use vagrant-berkself, you will have to install [ChefDK](https://downloads.chef.io/chef-dk/).
    * [vagrant-hosts](https://github.com/adrienthebo/vagrant-hosts)
          `$ vagrant plugin install vagrant-hosts`
    * [vagrant-cachier](https://github.com/fgrehm/vagrant-cachier)(optional)
          `$ vagrant plugin install vagrant-cachier`
    * [vagrant-aws](https://github.com/mitchellh/vagrant-aws) (only if you use ec2.)
    	   `$ vagrant plugin install vagrant-aws`

## Mesos Standalone on EC2

1. Set ec2 credentials and some configurations defined in `standalone/aws_config.yml`. You have to fill up `EDIT_HERE` parts.  Security group you'll set must accept at least tcp port 22(SSH) and 5050(mesos-master web ui) from outside of ec2.

		# Please set AWS credentials
		access_key_id:  EDIT_HERE
		secret_access_key: EDIT_HERE

		# Please choose one from
		# ["ap-northeast-1", "ap-southeast-1", "eu-west-1", "sa-east-1", "us-east-1",
		#  "us-west-1", "ap-southeast-2", "us-west-2"]
		region: us-east-1

		# array of security groups. e.g. ['sg*** ']
		security_groups: EDIT_HERE

		# See http://aws.amazon.com/ec2/instance-types/#selecting-instance-types
		# for other instance types and its specs.
		instance_type: m1.small

		keypair_name: EDIT_HERE

		ssh_private_key_path: EDIT_HERE

2. You can now spin up the Mesos box on ec2 with the following commands:

        cd standalone
        vagrant up --provider=aws

   After Vagrant has done it's thing, you can see the services running at:

   * Mesos web UI on: `http://#_public_dns_of_the_VM_#:5050`
   * [Marathon](https://github.com/mesosphere/marathon) web UI on: `http://#_public_dns_of_the_VM_#:8080`
   * [Chronos](https://github.com/mesos/chronos) web UI on: `http://#_public_dns_of_the_VM_#:8081`


	_Tips: you can get public dns of the vm by:_

	```
	$ vagrant ssh -- 'echo http://`curl --silent http://169.254.169.254/latest/meta-data/public-hostname`:5050'
	http://ec2-54-193-24-154.us-west-1.compute.amazonaws.com:5050
	```


## Mesos Cluster on EC2

### Cluster Configuration
Cluster configuration is defined at `multinodes/cluster.yml`.  You need to edit the file to configure cluster settings and also add in you AWS credentials as outlined in the next section.

```
# Mesos cluster configurations
mesos_version: 0.23.0

# The numbers of servers
##############################
zk_n: 1          # hostname will be zk1, zk2, …
master_n: 1      # hostname will be master1,master2,…
slave_n : 1      # hostname will be slave1,slave2,…

# Memory and Cpus setting(only for virtualbox)
##########################################
zk_mem     : 256
zk_cpus    : 1
master_mem : 256
master_cpus: 1
slave_mem  : 512
slave_cpus : 2

# private ip bases
# When ec2, this should be matched with
# private addresses defined by subnet_id below.
################################################
zk_ipbase    : "172.31.0."
master_ipbase: "172.31.1."
slave_ipbase : "172.31.2."
```

Because we assign private IP addreses to VM instances, this Vagrantfile requires Amazon VPC (you'll have to set subnet_id and security grooups both of which associates to the same VPC instance).

_Note: Using default VPC is highly recommended.  If you used non-default VPC, you should make sure to activate "DNS resolution" and "DNS hostname" feature in the VPC._

You have to configure some additional stuffs in `multinodes/cluster.yml` which are related to EC2.  Please note that

* `subnet_id` should be a VPC subnet
* `security_groups` should be ones associated to the VPC instance.
	* `security_groups` should allow accesses to ports 22(SSH), 2181(zookeeper) and 5050--(mesos).

```
(cont.)
# EC2 Configurations
# please choose one region from
# ["ap-northeast-1", "ap-southeast-1", "eu-west-1", "sa-east-1",
#  "us-east-1", "us-west-1", "ap-southeast-2", "us-west-2"]
# NOTE: if you used non-default vpc, you should make sure that
#       limit of the elastic ips is no less than (zk_n + master_n + slave_n).
#       In EC2, the limit default is 5.
########################
access_key_id:  EDIT_HERE
secret_access_key: EDIT_HERE
default_vpc: true                  # default vpc or not.
subnet_id: EDIT_HERE               # VPC subnet id
security_groups: ["EDIT_HERE"]     # array of VPN security groups. e.g. ['sg*** ']
keypair_name: EDIT_HERE
ssh_private_key_path: EDIT_HERE
region: EDIT_HERE

# see http://aws.amazon.com/ec2/instance-types/#selecting-instance-types
zk_instance_type: m1.small
master_instance_type: m1.small
slave_instance_type: m1.small
```


### Launch Cluster
This takes several minutes (10 to 30 min.).  Go grab some coffee :)

```
$ cd multinodes
$ vagrant up --provider=aws --no-parallel
```

_NOTE: `--no-parallel` is highly recommended because vagrant-berkshelf plugin is prone to failure in parallel provisioning._

After instances are all up, if everything went well you can now connect to the

* Mesos web UI on: `http://#_public_dns_of_the_master_N_#:5050`
* Marathon web UI on: `http://#_public_dns_of_marathon_#:8080`
* Chronos web UI on: `http://#_public_dns_of_chronos#:8081`


_Tips: you can get public dns of the vms by:_

```
$ vagrant ssh master1 -- 'echo http://`curl --silent http://169.254.169.254/latest/meta-data/public-hostname`:5050'
http://ec2-54-193-24-154.us-west-1.compute.amazonaws.com:5050
```

If you wanted to make sure that the specific mastar(e.g. `master1`) could be an initial leader, you can cotrol the order of spinning up VMs like below.

```
$ cd multinode
# spin up an zookeeper ensemble
$ vagrant up --provider=aws /zk/

# spin up master1. master1 will be an initial leader
$ vagrant up --provider=aws master1

# spin up remained masters
$ vagrant up --provider=aws /master[2-9]/

# spin up slaves
$ vagrant up --provider=aws /slave/

# spin up marathon
$ vagrant up --provider=aws marathon
```

#### Stop your Cluster
```
$ cd multinodes
$ vagrant halt
```

### Resume your Cluster
```
$ cd multinodes
$ vagrant reload --provision
```

#### Destroy your Cluster
This operations terminates all VMs instances forming the cluster.

```
$ cd multinodes
$ vagrant destroy
```
