#!/bin/sh

# {{{ start_banner()
start_banner()
{
	echo "############################################################"
	echo "# START SCRIPT"
	echo "############################################################"
}
# }}}

# {{{ destory_container()
destory_container(){
	echo "\n### START: Destory existing containers ##########"
	docker-compose \
		-f docker-compose.yml \
		-f docker-compose-attu.yml \
		down
}
# }}}

# {{{ clean_up_volume()
# $1: a volume folder to clean up
clean_up_volume(){
	VOL_DIR=$1
	echo "\n### START: Clean up a volume folder ##########"
	if [ -d $VOL_DIR ]; then
		# sort a processing depend on a directory's owner(yourself or other).
		if [ "$(ls -ld $VOL_DIR | awk '{print $3}')" = $USER ]; then
			rm -rf $VOL_DIR
		else
			sudo rm -rf $VOL_DIR
		fi
	fi
}
# }}}

# {{{ get_yaml_for_milvus()
# $1: URL of docker compose file to create Milvus
get_yaml_for_milvus(){
	VDB_YML=$1
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
		$VDB_YML \
		-O docker-compose.yml
}
# }}}

# {{{ create_container()
create_container(){
	echo "\n### START: Create new containers ##########"
	docker-compose \
		-f docker-compose.yml \
		-f docker-compose-attu.yml \
		up -d
}
# }}}

# {{{ show_list_container()
show_list_container(){
	echo "\n### START: Show a list of container ##########"
	docker ps -a
}
# }}}

# {{{ show_url()
show_url(){
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
}
# }}}

# {{{ finish_banner()
# $1: time to start this script
finish_banner(){
	S_TIME=$1
	E_TIME=$(date +%s)
	DURATION=$((E_TIME - S_TIME))
	echo "############################################################"
	echo "# FINISH SCRIPT ($DURATION seconds)"
	echo "############################################################"
}
# }}}

S_TIME=$(date +%s)
CUR_DIR=$(cd $(dirname $0); pwd)

VOL_DIR=$CUR_DIR/volumes/
VDB_YML=https://github.com/milvus-io/milvus/releases/download/v2.5.2/milvus-standalone-docker-compose.yml

case "$1" in
	"down")
		clear
		start_banner
		destory_container
		clean_up_volume $VOL_DIR
		show_list_container
		finish_banner $S_TIME
		;;
	"up")
		clear
		start_banner
		get_yaml_for_milvus $VDB_YML
		create_container
		show_list_container
		show_url
		finish_banner $S_TIME
		;;
	"list")
		clear
		show_list_container
		;;
	"")
		clear
		start_banner
		destory_container
		clean_up_volume $VOL_DIR
		get_yaml_for_milvus $VDB_YML
		create_container
		show_list_container
		show_url
		finish_banner $S_TIME
		;;
	*)
		echo "Usage: $0 [down|up|list]"
		echo ""
		exit 1
		;;
esac

