# this creates 2 partitions on /dev/sda
# the first is /  9GB big
# the second is filling up the remainder and mounts as /home

fdisk -u /dev/sda << EOF
n
p


+9G
n
p



w
EOF

mkfs.ext4 /dev/sda1
mkfs.ext4 /dev/sda2

mount /dev/sda1 /mnt
mkdir /mnt/home
mount /dev/sda2 /mnt/home

