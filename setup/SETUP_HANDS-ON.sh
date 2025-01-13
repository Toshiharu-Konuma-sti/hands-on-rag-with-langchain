#!/bin/sh

clear
S_TIME=$(date +%s)
CUR_DIR=$(cd $(dirname $0); pwd)

echo "############################################################"
echo "# START SCRIPT"
echo "############################################################"

$CUR_DIR/step01-install_python.sh

E_TIME=$(date +%s)
DURATION=$((E_TIME - S_TIME))

echo "############################################################"
echo "# FINISH SCRIPT ($DURATION seconds)"
echo "############################################################"
