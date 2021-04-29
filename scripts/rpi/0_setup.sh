# Ask for the administrator password upfront
sudo -v

sudo apt update
sudo apt upgrade -y

# create user?
# https://raspberrytips.com/new-user-on-raspberry-pi/

curl -sSL https://get.docker.com | sh
sudo usermod -aG docker pi
# sudo usermod -aG docker [created user]


# enable ssh
## todo, either add ssh file to SD, or systemctl enable ssh

# disable password auth for ssh
sudo vim /etc/ssh/sshd_config


