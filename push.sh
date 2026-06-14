#!/bin/bash
cd ~/uk-data-project
git add .
git commit -m "Update: $(date +'%Y-%m-%d %H:%M')"
git push
