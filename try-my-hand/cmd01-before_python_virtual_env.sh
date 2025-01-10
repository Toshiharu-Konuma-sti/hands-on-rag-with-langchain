#!/bin/sh

echo "### START: Create a virtual environment to execute python application ###########"
if [ "$(uname)" = "Darwin" ]; then	# for Mac
	virtualenv .venv
else
	python3 -m venv .venv
fi

cat << EOS
--------------------------------------------------
* Next, enter the command below to go to the python virtual environment!!

 source .venv/bin/activate

EOS
