#!/bin/bash

while [ $# -gt 1 ]; do
	if [ "$1" = "-o" ]; then
		touch "$2"
	fi
	shift
done

exit 0
