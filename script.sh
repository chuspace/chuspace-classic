sudo -s

dpkg-reconfigure tzdata

apt-get update -y && apt-get upgrade -y && apt-get autoremove -y && reboot
apt-get install libpq-dev -y

APP_NAME=git
adduser $APP_NAME --disabled-password

mkdir /home/$APP_NAME/.ssh
cp ~/.ssh/authorized_keys /home/$APP_NAME/.ssh/
chown $APP_NAME.$APP_NAME /home/$APP_NAME/.ssh -R
chmod go-rwx /home/$APP_NAME/.ssh -R

apt-get install git rng-tools autoconf bison build-essential libssl-dev libyaml-dev libreadline6-dev zlib1g-dev libncurses5-dev libffi-dev libgdbm5 libgdbm-dev -y

add-apt-repository ppa:certbot/certbot -y
apt-get update -y
apt-get install certbot python-certbot-nginx -y

DOMAIN=chuspace.com
WILDCARD=*.$DOMAIN

certbot -d $DOMAIN -d $WILDCARD --manual --preferred-challenges dns certonly
certbot -d $DOMAIN -d $WILDCARD --nginx --preferred-challenges dns certonly


sudo apt install gnupg apt-transport-https ca-certificates curl
add-apt-repository "deb https://apt.fullstaqruby.org ubuntu-18.04 main"
curl -SLfO https://raw.githubusercontent.com/fullstaq-labs/fullstaq-ruby-server-edition/master/fullstaq-ruby.asc
sudo apt-key add fullstaq-ruby.asc
sudo apt update


# VIPS

sudo apt-get install git build-essential libxml2-dev libfftw3-dev libmagickwand-dev libopenexr-dev liborc-0.4-0 gobject-introspection libgsf-1-dev libglib2.0-dev liborc-0.4-dev

aws acm import-certificate --certificate /etc/letsencrypt/live/chuspace.com-0001/cert.pem --private-key /etc/letsencrypt/live/chuspace.com-0001/privkey.pem --certificate-chain /etc/letsencrypt/live/chuspace.com-0001/chain.pem
