. "$SRC_ROOT/os.sh"

enter_suite()
{
    local os_release_path=/etc/os-release

    test_set_func 'os_release_lookup'
    if [ -e "$os_release_path" ]; then
        test_print info "$os_release_path contents:"
        while read line; do
            test_print info "$line"
        done < "$os_release_path"
        test_print info ''
        test_print info "$os_release_path lookups:"
        test_print info "NAME: [$(os_release_lookup NAME)]"
        test_print info "ID: [$(os_release_lookup ID)]"
        test_print info "NOOP: [$(os_release_lookup NOOP)]"
    else
        test_print warn "skipping test: os-release file not found at $os_release_path"
    fi
}
