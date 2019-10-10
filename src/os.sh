os_release_lookup()
{
    local attr=$1
    local val=$(grep "^$attr=" /etc/os-release 2>/dev/null | cut -d= -f2- || true)
    val=$(printf '%s' "$val" | tr -d "\"'")
    printf '%s\n' "$val"
}
