HOME=$1
USER=$2

sudo -u $USER mkdir -p $HOME/.ssh
sudo -u $USER chmod 700 $HOME/.ssh
sudo -u $USER cp /vagrant/scripts/sshkey/id_dsa $HOME/.ssh/id_dsa
sudo -u $USER chmod 600 $HOME/.ssh/id_dsa
sudo -u $USER cat /vagrant/scripts/sshkey/id_dsa.pub >> $HOME/.ssh/authorized_keys
sudo -u $USER chmod 600 $HOME/.ssh/authorized_keys
cat << EOT > $HOME/.ssh/config
host *
    StrictHostKeyChecking no
EOT
chown $USER $HOME/.ssh/config

