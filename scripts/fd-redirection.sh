#!/bin/bash
# exec id>&1 # duplicates fd 1 into fd on num id (up to 9)

# id> redirects fd of id into sth
# >(foo) redirects fd into subprocess 
# id>&- closes the fd of id
./foo.sh 3>&1 4>&2  1> >(tee -a log >/dev/null) 2> >(tee -a log >&4) 3>&- 4>&-
