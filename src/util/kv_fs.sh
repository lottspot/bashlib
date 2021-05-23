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

kv_purge_fs()
{
    local pattern=$1
    local fs_dir=$BASHLIB_KV_PATH
    rm -f "$fs_dir/"$pattern
}
