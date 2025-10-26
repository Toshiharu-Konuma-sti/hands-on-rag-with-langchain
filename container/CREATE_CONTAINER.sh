#!/bin/sh

S_TIME=$(date +%s)
CUR_DIR=$(cd $(dirname $0); pwd)
. ${CUR_DIR}/functions.sh
. ${CUR_DIR}/variables.sh

case "$1" in
	"down")
		clear
		start_banner
		destory_container "${CUR_DIR}" "${DOCK_COMP_MILV}" "${DOCK_COMP_ATTU}"
		show_list_container
		finish_banner ${S_TIME}
		;;
	"up")
		clear
		start_banner
		get_yaml_for_milvus "${YML_URL_MILV}" "${CUR_DIR}" "${DOCK_COMP_MILV}"
		modify_yaml_for_milvus "${CUR_DIR}" "${DOCK_COMP_MILV}"
		create_container "${CUR_DIR}" "${DOCK_COMP_MILV}" "${DOCK_COMP_ATTU}"
		show_list_container
		show_url "1"
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
		destory_container "${CUR_DIR}" "${DOCK_COMP_MILV}" "${DOCK_COMP_ATTU}"
		get_yaml_for_milvus "${YML_URL_MILV}" "${CUR_DIR}" "${DOCK_COMP_MILV}"
		modify_yaml_for_milvus "${CUR_DIR}" "${DOCK_COMP_MILV}"
		create_container "${CUR_DIR}" "${DOCK_COMP_MILV}" "${DOCK_COMP_ATTU}"
		show_list_container
		show_url "1"
		finish_banner ${S_TIME}
		;;
	*)
		show_usage
		exit 1
		;;
esac

