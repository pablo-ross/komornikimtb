#!/bin/bash

#set -e
#set -o pipefail

dt=$(date '+%Y-%m-%d %H:%M');

git pull
bundle exec rake strava:clubrides
bundle exec rake strava:members
if [ -f "./_pages/jezdzimy.md" ]; then
  git add "./_pages/jezdzimy.md"
fi
if [ -f "./_data/strava_members.yml" ]; then
  git add "./_data/strava_members.yml"
fi
git commit -m "Strava API cron update: $dt"
git push
