. "$SRC_ROOT/util.sh"

enter_suite()
{
    local lines=(l1 l2 l3)

    test_set_func 'join_lines'
    test_print info "$(printf 'printed array:\n%s\n' "${lines[*]}")"
    test_print info "$(printf 'join_lines:\n%s\n' "$(join_lines "${lines[@]}")")"
}
