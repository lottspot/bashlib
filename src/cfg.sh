declare -A CFG

parsecfg()
{
    # TODO: Error out on invalid lines
    local cfg_path=$1
    while read line; do
        ((++lnum)) # track line number
        if ! [ "$( printf '%s' "$line" | tr -d [:space:])" ]; then
            continue # skip empty lines
        elif [[ "$line" =~ ^[[:space:]]*# ]]; then
            continue # skip comment lines
        else
            line=${line%% #*} # strip inline comments
            key=$(printf '%s' ${line%%=*}  | tr [:upper:] [:lower:]) # keys case insensitive
            val=$(printf '%s' "${line#*=}" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//') # trim leading & trailing whitespace
            CFG[$key]=$val
        fi
    done < "$cfg_path"
}

resetcfg()
{
    unset CFG
    declare -A CFG
    export CFG
}

getvar()
{
    local varname=$1
    printf '%s' "${CFG[$varname]}"
}

getvar_lower()
{
    local varname=$1
    printf '%s' "${CFG[$varname]}" | tr '[:upper:]' '[:lower:]'
}
