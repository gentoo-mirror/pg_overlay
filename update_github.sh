#!/bin/bash
git commit -m "$1";git checkout master;git add *;git commit -m "$1";git push origin master
