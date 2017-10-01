#!/bin/bash

ORANGE='\033[0;33m'
NC='\033[0m'

POSITIONAL=()
while [[ $# -gt 0 ]]
do
key="$1"

case $key in
    -u|--update)
    UPDATE="$2"
    shift # past argument
    shift # past value
    ;;
    *)    # unknown option
    POSITIONAL+=("$1") # save it in an array for later
    shift # past argument
    ;;
esac
done
set -- "${POSITIONAL[@]}" # restore positional parameters

if [[ (! -f images/raspbian-stretch-lite.img) || (${UPDATE+x}) ]]; then
  echo -e "${ORANGE}Updating raspbian stretch image. downloading to ./images...${NC}"
  rm -rf images
  mkdir images
  if [[ -f $UPDATE ]]; then
    echo -e "${ORANGE}Using existing image under ${UPDATE}...${NC}"
    cp $UPDATE "images/raspbian-stretch-lite.img"
  else
    wget https://downloads.raspberrypi.org/raspbian_lite_latest -O /tmp/raspbian_lite_latest.zip
    unzip -p /tmp/raspbian_lite_latest.zip > "images/raspbian-stretch-lite.img"
    rm -rf /tmp/raspbian_lite_latest.zip
  fi
fi

./qemu-pi.sh images/raspbian-stretch-lite.img