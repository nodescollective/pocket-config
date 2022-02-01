#!/bin/bash -xe
cd /home/ec2-user
curl -LO https://harmony.one/hmycli && mv hmycli hmy && chmod +x hmy
yum install openssl
openssl rand -base64 32 > pass.txt
./hmy keys generate-bls-keys --count 1 --shard 1 --passphrase-file pass.txt
mkdir -p .hmy/blskeys
cp *.key .hmy/blskeys
cat pass.txt > .hmy/blskeys/$(find . -name *.key | cut -c 3- | cut -f 1 -d '.').pass
curl https://rclone.org/install.sh | sudo bash
mkdir -p /home/ec2-user/.config/rclone
export CONFIG=/home/ec2-user/.config/rclone/rclone.conf
cat<<-EOF > $CONFIG
  [release]
  type = s3
  provider = AWS
  env_auth = false
  region = us-west-1
  acl = public-read
  server_side_encryption = AES256
  storage_class = REDUCED_REDUNDANCY
EOF
rclone -P -L sync release:pub.harmony.one/mainnet.min/harmony_db_0 harmony_db_0 --multi-thread-streams 4 --transfers=8 --config="$CONFIG"
curl -LO https://harmony.one/binary && mv binary harmony && chmod +x harmony
/home/ec2-user/harmony -V
curl -O https://raw.githubusercontent.com/nodescollective/pocket-config/main/harmony-0/harmony.conf
./harmony --run=explorer --run.archive --run.shard=0 --db_dir=./ 2>> chain.log
