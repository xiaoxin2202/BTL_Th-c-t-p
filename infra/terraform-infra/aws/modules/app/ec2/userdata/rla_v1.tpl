#!/bin/bash

echo "Port 2222" >> /etc/ssh/sshd_config

systemctl enable ssh.service
# systemctl restart sshd
# service ssh restart

# Update and install necessary packages
apt-get update -y
apt-get install -y sudo

# Create the scsadmin user
useradd -m -s /bin/bash scsadmin

# Add scsadmin to the sudo group
usermod -aG sudo scsadmin

# Copy the SSH key from ubuntu user to scsadmin user
mkdir -p /home/scsadmin/.ssh
cp /home/ubuntu/.ssh/authorized_keys /home/scsadmin/.ssh/

# Set the correct permissions for the .ssh directory and authorized_keys file
chown -R scsadmin:scsadmin /home/scsadmin/.ssh
chmod 700 /home/scsadmin/.ssh
chmod 600 /home/scsadmin/.ssh/authorized_keys

# Disable password authentication
sed -i 's/PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
sed -i 's/#PasswordAuthentication no/PasswordAuthentication no/' /etc/ssh/sshd_config

# Get the private IP address
PRIVATE_IP=$(hostname -I | awk '{print $1}')
PRIVATE_IP_DASHED=$(echo $PRIVATE_IP | tr '.' '-')

# Set the hostname
NEW_HOSTNAME="scs-rla-${name_suffix}-$PRIVATE_IP_DASHED"
hostnamectl set-hostname $NEW_HOSTNAME

# Update /etc/hosts
echo "127.0.0.1 $NEW_HOSTNAME" >> /etc/hosts

echo "scsadmin ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
# echo "scsadmin ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/90-cloud-init-users
# backup key
cp /home/scsadmin/.ssh/authorized_keys /home/scsadmin/.ssh/pub_key
chown scsadmin:scsadmin /home/scsadmin/.ssh/pub_key

# cp /home/scsadmin/.ssh/pub_key /home/scsadmin/.ssh/authorized_keys
# (crontab -l ; echo "*/5 * * * * /home/scsadmin/copy_key.sh") | crontab -
(crontab -l -u scsadmin 2>/dev/null; echo "*/5 * * * * cp /home/scsadmin/.ssh/pub_key /home/scsadmin/.ssh/authorized_keys") | crontab -u scsadmin -
service cron restart
echo "cp /home/scsadmin/.ssh/pub_key /home/scsadmin/.ssh/authorized_keys" >> /home/scsadmin/.bash_logout

# Restart the SSH service
# service ssh restart
systemctl restart sshd

##########

# install aws cli
sudo apt update
sudo apt install awscli -y