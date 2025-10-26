
# {{{ start_banner()
start_banner()
{
	echo "############################################################"
	echo "# START SCRIPT"
	echo "############################################################"
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
		-O docker-compose-milvus.yml
}
# }}}

# {{{ modify_yaml_for_milvus()
modify_yaml_for_milvus()
{
	cat << EOS >> ${CUR_DIR}/docker-compose-milvus.yml


volumes:
  milvus-etcd:
  milvus-minio:
  milvus-data:
EOS

	sed -i.bak \
		-e "s#\${DOCKER_VOLUME_DIRECTORY:-\.}/volumes/etcd#milvus-etcd#" \
		-e "s#\${DOCKER_VOLUME_DIRECTORY:-\.}/volumes/minio#milvus-minio#" \
		-e "s#\${DOCKER_VOLUME_DIRECTORY:-\.}/volumes/milvus#milvus-data#" \
		${CUR_DIR}/docker-compose-milvus.yml
	rm -f "${CUR_DIR}/docker-compose-milvus.yml.bak"
}
# }}}

# {{{ create_container()
create_container(){
	echo "\n### START: Create new containers ##########"
	docker-compose \
		-f docker-compose-milvus.yml \
		-f docker-compose-attu.yml \
		up -d
}
# }}}

# {{{ destory_container()
destory_container(){
	echo "\n### START: Destory existing containers ##########"
	docker-compose \
		-f docker-compose-milvus.yml \
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

#	if [ "$(uname)" = 'Darwin' ]; then	# for Mac
#		open http://localhost:8000
#	fi
}
# }}}

# {{{ show_usage()
show_usage()
{
	cat << EOS
Usage: $(basename $0) [options]

Start the containers needed for the hands-on. If there are any containers
already running, stop them and remove resources beforehand.

Options:
  up                    Start the containers.
  down                  Stop the containers and remove resources.
  list                  Show the list of containers.
  info                  Show the information such as URLs.

EOS
}
# }}}

