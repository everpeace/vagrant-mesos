apt-get remove lxc-docker -y
apt-get purge lxc-docker
chmod +x /vagrant/scripts/docker.sh
/vagrant/scripts/docker.sh
service docker restart
service mesos-slave restart
# Setup
#sudo apt-key adv --keyserver keyserver.ubuntu.com --recv E56151BF
#DISTRO=$(lsb_release -is | tr '[:upper:]' '[:lower:]')
#CODENAME=$(lsb_release -cs)

# Add the repository
#echo "deb http://repos.mesosphere.com/${DISTRO} ${CODENAME} main" | \
#  sudo tee /etc/apt/sources.list.d/mesosphere.list
#sudo apt-get -y update
