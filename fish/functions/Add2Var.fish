function Add2Var --description="Add value to exported variable"

    set -x $argv[1] $argv[2] $$argv[1]
    
end
