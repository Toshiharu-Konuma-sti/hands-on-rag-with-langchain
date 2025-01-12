#!/bin/sh

echo "### START: Install pip in python ##########"
which pip
if [ $? -ne 0 ]; then
	cat << EOS
############################################################
### Notice:
### - This script was interruped. Please install pip first.
############################################################
EOS
	exit
fi

echo "### START: Install a tool to create isolated Python environment ##########"
if [ "$(uname)" = "Darwin" ]; then	# for Mac
	pip install virtualenv
else
	sudo apt install -y python-is-python3 python3-pip python3-venv
fi
