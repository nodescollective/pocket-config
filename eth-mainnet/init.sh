#!/bin/bash -xe
PORT=$1
sudo yum -y update
sudo yum -y install golang
sudo yum -y install git
cd /home/ec2-user
mkdir tmp
export GOCACHE=/home/ec2-user/tmp
export GOPATH=/home/ec2-user/go
git clone https://github.com/ethereum/go-ethereum
cd go-ethereum/ || exit
make geth
./build/bin/geth --http --http.port $PORT --http.addr 0.0.0.0 --http.corsdomain '*' --http.api 'eth,web3' --http.vhosts '*' 2>> /home/ec2-user/chain.log
