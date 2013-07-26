MESOS_INSTALL_DIR=/home/vagrant
MESOS_HOME=$MESOS_INSTALL_DIR/mesos
MESOS_BUILD_DIR=$MESOS_HOME/build
MESOS_DEPLOY_CONF_DIR=/usr/local/var/mesos/deploy

cd $MESOS_INSTALL_DIR
git clone https://github.com/apache/mesos.git

cd $MESOS_HOME
./bootstrap
mkdir -p $MESOS_BUILD_DIR && cd $MESOS_BUILD_DIR
../configure
make
make check  # comment out if some tests failed.
sudo make install
sudo ldconfig

# deploy default configuration settings
sudo cp /vagrant/scripts/conf/* $MESOS_DEPLOY_CONF_DIR
