declare -A KV_MEM
export BASHLIB_KV_PATH=':mem:'

kv()
{
    local key=$1
    local val=$2
    local backend=$(kv_backend)
    local kv_func=kv_backend_mem

    test "$backend" = ':mem:' || kv_func=kv_backend_fs

    $kv_func "$key" "$val"
}

kv_purge()
{
    local pattern=$1
    local backend=$(kv_backend)
    local purge_func=kv_purge_mem

    test "$backend" = ':mem:' || purge_func=kv_purge_fs

    $purge_func "$pattern"
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

kv_purge_mem()
{
    local pattern=$1
    for key in "${!KV_MEM[@]}"; do
        [[ $key == $pattern ]] && unset KV_MEM[$key]
    done
    return 0
}
