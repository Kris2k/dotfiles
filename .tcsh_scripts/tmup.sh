#!/bin/tcsh
# script to reload tmux envroment
# for each value that starts with '-' do unset that variable (first if)
# for each value that looks v=foo 123 bar do setenv foo 123 bar
foreach v ( "`tmux show-environment`" )
	if ( "$v" =~ -* ) then
         unset ${v:s/-//}
	else
        # split variables on equal sign so x=foo 123 becames array "x foo 123"
		set split=( ${v:s/=/ /} )
        # now setenv for first arg of the split e.g x
        #     the value of x will be "foo 123", the `"' is to concatenate the rest of the list
	    setenv $split[1] "$split[2*]"
        unset split
	endif
end
unset v
