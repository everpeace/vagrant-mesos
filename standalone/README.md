please read <https://github.com/everpeace/vagrant-mesos>.



vagrant plugin uninstall vagrant-berkshelf
vagrant plugin uninstall vagrant-cachier
vagrant plugin uninstall vagrant-hosts
vagrant plugin uninstall vagrant-omnibus

vagrant plugin install vagrant-berkshelf --plugin-version 1.3.7
vagrant plugin install vagrant-cachier --plugin-version 0.6.0
vagrant plugin install vagrant-hosts  --plugin-version 2.1.2
vagrant plugin install vagrant-omnibus --plugin-version 1.3.1


vagrant plugin install vagrant-vmware-fusion
vagrant plugin license vagrant-vmware-fusion license.lic

vagrant up


------------------------


Chef error?

[2014-04-29T11:47:22-07:00] ERROR: You must specify at least one cookbook repo path


vagrant destroy
rm -rf ~/.vagrant.d

vagrant plugin install vagrant-berkshelf --plugin-version 1.3.7
vagrant plugin install vagrant-cachier --plugin-version 0.6.0
vagrant plugin install vagrant-hosts  --plugin-version 2.1.2
vagrant plugin install vagrant-omnibus --plugin-version 1.3.1
vagrant plugin install vagrant-vmware-fusion
vagrant plugin license vagrant-vmware-fusion license.lic

vagrant up
