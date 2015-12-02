wget -nv --directory-prefix=/usr/lib https://github.com/emccode/mesos-module-dvdi/releases/download/v0.1.0/libmesos_dvdi_isolator-0.23.0.so
cp /vagrant/scripts/conf_templates/dvdi-mod.json /usr/lib
#cp /vagrant/scripts/conf_templates/isolation /etc/mesos-slave
cp /vagrant/scripts/conf_templates/modules /etc/mesos-slave
