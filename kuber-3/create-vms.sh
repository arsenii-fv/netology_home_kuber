#!/bin/bash

set -e

function create_vm {
  local NAME=$1

  YC=$(cat <<END
    yc compute instance create \
      --name $NAME \
      --hostname $NAME \
      --zone ru-central1-b \
      --network-interface subnet-name=default-ru-central1-b,nat-ip-version=ipv4 \
      --memory 2 \
      --cores 2 \
      --create-boot-disk image-folder-id=standard-images,image-family=ubuntu-2004-lts,type=network-ssd,size=20 \
      --ssh-key /home/atman/.ssh/id_ecdsa.pub
END
)
#  echo "$YC"
  eval "$YC"
}

create_vm "master1"
# create_vm "master2"
# create_vm "master3"
create_vm "skyn1"
create_vm "skyn2"
# create_vm "skyn3"
