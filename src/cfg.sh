cfg_depends=(
    trim
)

for dep in "${cfg_depends[@]}"; do
    if ! type $dep >/dev/null 2>&1; then
        if [ "$(basename "${BASH_SOURCE[0]}")" = 'cfg.sh' ]; then
            printf '%s load error: missing dependency: %s\n' 'cfg.sh' "$dep" >&2
            return 1
        else
            printf '%s load error: missing dependency: %s\n' "$0" "$dep" >&2
            exit 1
        fi
    fi
done

declare -A CFG

cfg_parse()
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
            val=$(trim "${line#*=}")
            CFG[$key]=$val
        fi
    done < "$cfg_path"
}

cfg_reset()
{
    unset CFG
    declare -A CFG
    export CFG
}

cfg_get()
{
    local varname=$1
    printf '%s' "${CFG[$varname]}"
}

cfg_getlower()
{
    local varname=$1
    printf '%s' "${CFG[$varname]}" | tr '[:upper:]' '[:lower:]'
}
