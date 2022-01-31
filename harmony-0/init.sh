#!/bin/bash -xe
cd /home/ec2-user
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
/home/ec2-user/harmony config dump harmony.conf
