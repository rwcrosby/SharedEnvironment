function gitnp --wraps=git --description='Git with no pager'

    command git --no-pager $argv 
    
end