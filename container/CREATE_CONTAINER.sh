#!/bin/sh

S_TIME=$(date +%s)
CUR_DIR=$(cd $(dirname $0); pwd)
. ${CUR_DIR}/functions.sh
. ${CUR_DIR}/variables.sh

VOL_DIR=${CUR_DIR}/volumes/

case "$1" in
	"down")
		clear
		start_banner
		destory_container
		clean_up_volume $VOL_DIR
		show_list_container
		finish_banner ${S_TIME}
		;;
	"up")
		clear
		start_banner
		get_yaml_for_milvus $VDB_YML
		modify_yaml_for_milvus ${CUR_DIR}
		create_container
		show_list_container
		show_url
		finish_banner ${S_TIME}
		;;
	"list")
		clear
		show_list_container
		;;
	"info")
		show_url
		;;
	"")
		clear
		start_banner
		destory_container
#		clean_up_volume $VOL_DIR
		get_yaml_for_milvus $VDB_YML
		modify_yaml_for_milvus ${CUR_DIR}
		create_container
		show_list_container
		show_url
		finish_banner ${S_TIME}
		;;
	*)
		show_usage
		exit 1
		;;
esac

