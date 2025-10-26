#!/bin/sh

CUR_DIR=$(cd $(dirname $0); pwd)
. ${CUR_DIR}/functions.sh

call_show_start_banner

echo "### START: Install pip and a tool to create isolated Python environment ##########"
if [ "$(uname)" = "Darwin" ]; then	# for Mac
	which pip
	if [ $? -ne 0 ]; then
		python3 -m ensurepip
	fi
	pip install virtualenv
else
	which python3
	if [ $? -ne 0 ]; then
		sudo apt install -y python3-pip
	fi
	python3 -c "import venv"
	if [ $? -ne 0 ]; then
		sudo apt install -y python3-venv
	fi
fi

call_show_finish_banner
