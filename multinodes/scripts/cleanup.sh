apt-get remove lxc-docker -y
apt-get purge lxc-docker
chmod +x /vagrant/scripts/docker.sh
/vagrant/scripts/docker.sh
service docker restart
service mesos-slave restart
