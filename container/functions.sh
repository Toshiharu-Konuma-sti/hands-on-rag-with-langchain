
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


# {{{ call_own_fname()
call_own_fname()
{
	OFNM=$(basename $0)
	echo "$OFNM"
}
# }}}

# {{{ call_path_of_container()
# $1: the current directory
call_path_of_container()
{
	TARGET=$(realpath $1/../container)
	echo "$TARGET"
}
# }}}

# {{{ call_path_of_setup()
# $1: the current directory
call_path_of_setup()
{
	TARGET=$(realpath $1/../setup)
	echo "$TARGET"
}
# }}}

# {{{ call_path_of_development()
# $1: the current directory
call_path_of_development()
{
	TARGET=$(realpath $1/../development)
	echo "$TARGET"
}
# }}}

# {{{ call_path_of_experience()
# $1: the current directory
call_path_of_experience()
{
	TARGET=$(realpath $1/../try-my-hand)
	echo "$TARGET"
}
# }}}

# {{{ call_show_start_banner()
# $0: the name of the script being executed 
call_show_start_banner()
{
	echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\n> START: Script = [$(call_own_fname)]\n>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
}
# }}}

# {{{ call_show_finish_banner()
# $0: the name of the script being executed 
call_show_finish_banner()
{
	echo "\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<\n< FINISH: Script = [$(call_own_fname)]\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
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
	wget $VDB_YML -O docker-compose-milvus.yml
}
# }}}

# {{{ modify_yaml_for_milvus()
modify_yaml_for_milvus()
{
	CUR_DIR=$1

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
clean_up_volume(){
	echo "\n### START: Clean up volumes ##########"
	docker volume rm milvus-etcd
	docker volume rm milvus-minio
	docker volume rm milvus-data
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

