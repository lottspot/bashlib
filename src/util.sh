# print arguments as a series of lines
# useful for printing arrays as lines`
join_lines()
{
    local IFS=$'\n'
    printf '%s\n' "$*"
}
