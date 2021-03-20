#!/bin/sh
if [ $# = "1" ]; then
	if [ $1 = "b" ]; then
		docker-compose build
	fi;
fi;

docker-compose run pdag_extensions