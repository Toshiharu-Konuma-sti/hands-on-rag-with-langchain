#!/bin/sh

clear
S_TIME=$(date +%s)
CUR_DIR=$(cd $(dirname $0); pwd)

echo "############################################################"
echo "# START SCRIPT"
echo "############################################################"

VOL_DIR=$CUR_DIR/volumes/

echo "\n### START: Destory existing containers ##########"
docker-compose \
	-f docker-compose.yml \
	-f docker-compose-attu.yml \
	down

echo "\n### START: Clean up a volume folder ##########"
if [ -d $VOL_DIR ]; then
	# sort a processing depend on a directory's owner(yourself or other).
	if [ "$(ls -ld $VOL_DIR | awk '{print $3}')" = $USER ]; then
		rm -rf $VOL_DIR
	else
		sudo rm -rf $VOL_DIR
	fi
fi

echo "\n### START: Get docker-compose.yml from Milvus's git repogitory  ##########"
which wget
if [ $? -ne 0 ]; then
	if [ "$(uname)" = "Darwin" ]; then
		brew install wget
	else
		sudo apt install wget
	fi
fi
wget \
	https://github.com/milvus-io/milvus/releases/download/v2.5.0-beta/milvus-standalone-docker-compose.yml \
	-O docker-compose.yml

echo "\n### START: Create new containers ##########"
docker-compose \
	-f docker-compose.yml \
	-f docker-compose-attu.yml \
	up -d

echo "\n### START: Show a list of container ##########"
docker ps -a

cat << EOS

/************************************************************
 * Information:
 * - Used a material at the following URL as a reference to create Milvus containers.
 *   - https://milvus.io/docs/ja/install_standalone-docker-compose.md
 * - Access to Attu (Web admin tool for Milvus) with the URL below.
 *   - http://localhost:8000
 ***********************************************************/

EOS

if [ "$(uname)" = 'Darwin' ]; then	# for Mac
	open http://localhost:8000
fi

E_TIME=$(date +%s)
DURATION=$((E_TIME - S_TIME))

echo "############################################################"
echo "# FINISH SCRIPT ($DURATION seconds)"
echo "############################################################"
