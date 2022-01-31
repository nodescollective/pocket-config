#!/bin/bash -xev
sudo yum -y update
sudo yum -y install golang
#yum -y install git # unnecessary, go dependency
export HOME=/home/ec2-user
cd $HOME
mkdir tmp
export GOCACHE=$HOME/tmp
export GOPATH=$HOME/go
MAIN_SEEDS='03b74fa3c68356bb40d58ecc10129479b159a145@seed1.mainnet.pokt.network:20656,64c91701ea98440bc3674fdb9a99311461cdfd6f@seed2.mainnet.pokt.network:21656,0057ee693f3ce332c4ffcb499ede024c586ae37b@seed3.mainnet.pokt.network:22856,9fd99b89947c6af57cd0269ad01ecb99960177cd@seed4.mainnet.pokt.network:23856,1243026603e9073507a3157bc4de99da74a078fc@seed5.mainnet.pokt.network:24856,6282b55feaff460bb35820363f1eb26237cf5ac3@seed6.mainnet.pokt.network:25856,3640ee055889befbc912dd7d3ed27d6791139395@seed7.mainnet.pokt.network:26856,1951cded4489bf51af56f3dbdd6df55c1a952b1a@seed8.mainnet.pokt.network:27856,a5f4a4cd88db9fd5def1574a0bffef3c6f354a76@seed9.mainnet.pokt.network:28856,d4039bd71d48def9f9f61f670c098b8956e52a08@seed10.mainnet.pokt.network:29856,5c133f07ed296bb9e21e3e42d5f26e0f7d2b2832@poktseed100.chainflow.io:26656'
echo "seeds: $MAIN_SEEDS"
git clone https://github.com/pokt-network/pocket-core.git
cd $HOME/pocket-core
git checkout tags/RC-0.7.1
go build -o $GOPATH/bin/pocket ./app/cmd/pocket_core/main.go
# /home/ec2-user/go/bin/pocket start --mainnet
mkdir -p /home/ec2-user/.pocket/config/
cd /home/ec2-user/.pocket/config/
curl -O https://raw.githubusercontent.com/pokt-network/pocket-network-genesis/master/mainnet/genesis.json
curl -O https://raw.githubusercontent.com/nodescollective/pocket-config/main/config.json
sed -i 's/changeme/home\/ec2-user/g' /home/ec2-user/.pocket/config/config.json
wget -qO- https://link.us1.storjshare.io/raw/jvbdktddq6xg2vbkw7toelog5lqa/pocket-public-blockchains/pocket-network-data-1217-rc-0.6.3.6.tar | tar xvf -
