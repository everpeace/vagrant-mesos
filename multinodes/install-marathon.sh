
sudo apt-get -y update
sudo apt-get install -y software-properties-common
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv E56151BF
sudo add-apt-repository -y ppa:webupd8team/java
sudo apt-get update -y

echo debconf shared/accepted-oracle-license-v1-1 select true | sudo debconf-set-selections
echo debconf shared/accepted-oracle-license-v1-1 seen true | sudo debconf-set-selections
sudo apt-get install -y --force-yes oracle-java8-installer oracle-java8-set-default
sudo apt-get install marathon chronos
sudo service marathon start
sudo service chronos start
