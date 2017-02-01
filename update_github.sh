#!/bin/bash
#PACKAGE="$1"
git add *;git commit -m "$(pwd | cut -d/ -f5,6)";git push origin master
