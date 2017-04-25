#!/bin/bash
# example for awk RS (Record Separator)
git dfs|awk 'BEGIN { RS="diff --git" }  {file=$2; if ( match($0,/old mode 100755/) != 0 && match($0,/new mode 100644/) != 0 ) { print "git update-index --chmod+x " file; }  }'
