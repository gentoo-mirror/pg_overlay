#!/bin/bash
git commit -m "$1";git checkout overlord;git add *;git commit -m "$1";git push origin overlord
