XPTemplate priority=personal+
XPTinclude
      \ sh/sh
        
"XPTinclude
"      \ _common/common
"      \ _printf/c.like


XPT help-variables " special shell variables
# $#     number of args
# $?     last exit status            
# $$     this shell pid, use in make for unique names           
# $!     pid of the last command run in the background.
# $*     all the arguments  starting at $1. '1 2' 3 becomes "1 2 3". when "$*"
# $@     same as above, except when quoted. '1 2' 3 becomes "1 2" "3" when "$@"
# $-     options supplied to this shell. ?? was

