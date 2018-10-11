function la --wraps=ls --description='All Directory Listing'

    command ls $LS_OPTIONS -lA --group-directories-first --time-style="+%Y-%m-%d %H:%M:%S" $argv 
    
end