echo 'REXRAY_STORAGEDRIVERS=ec2' >> /etc/environment
echo 'AWS_ACCESS_KEY='$1 >> /etc/environment
echo 'AWS_SECRET_KEY='$2 >> /etc/environment
curl -sSL https://dl.bintray.com/emccode/rexray/install | sh -
#cp /vagrant/scripts/conf_templates/rexray.conf /etc/init/rexray.conf
service rexray start
#/bin/rexray --daemon --host=unix:///run/docker/plugins/rexray.sock > /dev/null 2>&1
