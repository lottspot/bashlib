#
# STDOUT PRINTING
#

print_color()
{
    # Options:
    # -b         Print in bold font
    # -c [color] Print in specified color

    local code=
    local OPTIND=1
    while getopts ':bc:' arg "$@"; do
        case $arg in
            b) local bold=1;;
            c) local color=$OPTARG;;
        esac
    done
    shift $((OPTIND-1))

    if [ "$bold" ]; then
        code="1"
    fi

    case $color in
        black)      code="${code};30";;
        red)        code="${code};31";;
        green)      code="${code};32";;
        yellow)     code="${code};33";;
        blue)       code="${code};34";;
        magenta)    code="${code};35";;
        cyan)       code="${code};36";;
        white)      code="${code};37";;
    esac

    printf -- '\x1b[0;%sm%s\x1b[0m\n' "$code" "$*"
}
