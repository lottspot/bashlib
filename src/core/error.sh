#
# STDERR FD CONTROL
#

unset stderrfd

stderr_hide()
{
    test -v stderrfd || exec {stderrfd}>&2
    exec 2>/dev/null
}

stderr_show()
{
    if [ -v stderrfd ]; then
        exec 2>&$stderrfd
        exec {stderrfd}>&-
        unset stderrfd
    fi
}

#
# STDERR PRINTING
#

print_e()
{
    if [ -v stderrfd ]; then
        printf -- '%s\n' "$*" >&$stderrfd
    else
        printf -- '%s\n' "$*" >&2
    fi
}

#
# PROCESS CONTROL
#

die()
{
    print_e "$@"
    exit 1
}
