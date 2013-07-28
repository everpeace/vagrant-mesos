MESOS_INSTALL_DIR=$1
MESOS_PREFIX=$2

MESOS_DIR=$MESOS_INSTALL_DIR/mesos
MESOS_BUILD_DIR=$MESOS_DIR/build

cd $MESOS_INSTALL_DIR
git clone https://github.com/apache/mesos.git

cd $MESOS_DIR
./bootstrap
mkdir -p $MESOS_BUILD_DIR && cd $MESOS_BUILD_DIR
../configure --prefix=$MESOS_PREFIX
make
# chown -R  $MESOS_DIR
# sudo make check  # comment out if some tests failed.

