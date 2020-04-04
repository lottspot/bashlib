declare -A KV_MEM
export BASHLIB_KV_PATH=':mem:'

kv()
{
    local key=$1
    local val=$2
    local backend=$(kv_backend)
    local kv_func=kv_backend_mem

    if [ "$backend" != ':mem:' ]; then
        kv_func=kv_backend_fs
    fi

    $kv_func "$key" "$val"
}

kv_backend()
{
    local path=$1

    if [ "$path" ]; then
        # Setter
        BASHLIB_KV_PATH=$path
    else
        # Getter
        printf '%s\n' "$BASHLIB_KV_PATH"
    fi
}

kv_backend_mem()
{
    local key=$1
    local val=$2

    if [ -n "$val" ]; then
        # Setter
        KV_MEM[$key]=$val
    else
        # Getter
        printf '%s' "${KV_MEM[$key]}"
    fi
}

kv_backend_fs()
{
    local key=$1
    local val=$2
    local fs_dir=$BASHLIB_KV_PATH
    local fs_path=$fs_dir/$key

    test -e "$fs_dir" || mkdir -p "$fs_dir"

    if [ -n "$val" ]; then
        # Setter
        printf '%s' "$val" > "$fs_path"
    else
        # Getter
        printf '%s' "$(cat "$fs_path" 2>/dev/null)"
    fi
}
