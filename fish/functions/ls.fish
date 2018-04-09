function ls --wraps=ls --description='Short Directory Listing'

    command ls $LS_OPTIONS --group-directories-first --time-style="+%Y-%m-%d %H:%M:%S" $argv 
    
end