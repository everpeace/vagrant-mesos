#! /bin/bash
MESOS_INSTALL_DIR=$1
MESOS_PREFIX=$2
HOSTNAME=$3

MESOS_DIR=$MESOS_INSTALL_DIR/mesos
MESOS_BUILD_DIR=$MESOS_DIR/build
MESOS_DEPLOY_CONF_DIR=$MESOS_PREFIX/var/mesos/deploy

cd $MESOS_BUILD_DIR
make install
ldconfig

# deploy default configuration settings
cp /vagrant/generated/mesos_conf/* $MESOS_DEPLOY_CONF_DIR
if [[ "$HOSTNAME" =~ master[0-9]+  ]]; then
  ln -sf $MESOS_DEPLOY_CONF_DIR/mesos-$HOSTNAME-env.sh $MESOS_DEPLOY_CONF_DIR/mesos-master-env.sh
fi
if [[ "$HOSTNAME" =~ slave[0-9]+ ]]; then
  ln -sf $MESOS_DEPLOY_CONF_DIR/mesos-$HOSTNAME-env.sh $MESOS_DEPLOY_CONF_DIR/mesos-slave-env.sh
fi
cp /vagrant/generated/zk_conf/zoo.cfg $MESOS_BUILD_DIR/3rdparty/zookeeper-3.3.4/conf/zoo.cfg

