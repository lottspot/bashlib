SCRIPT=$_
TEST_ROOT=$(dirname "$SCRIPT")
SRC_ROOT=$TEST_ROOT/../src
TEST_SUITE_NAME=
TEST_FUNC_NAME=

. "$SRC_ROOT/header.sh"

test_print()
{
    local objname=$1
    local suite_name_maxlen=20
    local func_name_maxlen=25
    local prefix_suite=$(printf "%-${suite_name_maxlen}s%s" "$(print_color -bc cyan "$TEST_SUITE_NAME")" "$(print_color -bc cyan ':')")
    local prefix_func=$(printf "%-${func_name_maxlen}s%s" "$(print_color -bc yellow "$TEST_FUNC_NAME")" "$(print_color -bc yellow ':')")
    local prefix="$prefix_suite $prefix_func"
    shift

    case $objname in
        info)
                local prefix="$prefix $(print_color -c green '+')"
                local item="$*"
        ;;
        error)
                local prefix="$prefix $(print_color -bc red 'x')"
                local item=$(print_color -c red "$*")
        ;;
    esac

    printf '%s %s\n' "$prefix" "$item"
}

test_set_suite()
{
    TEST_SUITE_NAME=$1
    print_color -bc white "SUITE: ${1^^}"
}

test_set_func(){
    TEST_FUNC_NAME=$1
}

enter_suite_header()
{
    test_set_func 'stderr_hide'
    printf '%s\n' "$(test_print info 'This message prints before stderr_hide')" >&2
    stderr_hide
    printf '%s\n' "$(test_print error 'THIS SHOULD NOT PRINT')" >&2
    print_e "$(test_print info 'This message prints after stderr_hide')"
    test_set_func 'stderr_show'
    stderr_show
    printf '%s\n' "$(test_print info 'This message prints after stderr_show')" >&2
}

#
# MAIN
#

if ! [ "$1" ]; then
    # Run all suites
    test_set_suite 'header'
    enter_suite_header
    for src in $TEST_ROOT/*.sh; do
        if [[ $src =~ .*/run.sh$ ]]; then
            continue
        fi
        script_name=$(basename "$src")
        suite_name=${script_name%.sh}
        unset enter_suite
        source "$src" || die "error loading suite: $suit_name"
        test_set_suite $suite_name
        enter_suite
    done
elif [ "$1" = 'header' ]; then
    test_set_suite 'header'
    enter_suite_header
else
    unset enter_suite
    source "$TEST_ROOT/$1.sh" || die "error loading suite: $1"
    test_set_suite "$1"
    enter_suite
fi
