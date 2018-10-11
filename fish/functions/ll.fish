function ll --wraps=ls --description='Long Directory Listing'

    command ls $LS_OPTIONS -l --group-directories-first --time-style="+%Y-%m-%d %H:%M:%S" $argv 
    
end