#!/bin/sh

VNAME=.venv

echo "### START: Create a virtual environment to execute python application ###########"
if [ "$(uname)" = "Darwin" ]; then	# for Mac
	virtualenv $VNAME
else
	python3 -m venv $VNAME
fi

cat << EOS
--------------------------------------------------
* Next, enter the command below to go to the python virtual environment!!

 source ${VNAME}/bin/activate

EOS
