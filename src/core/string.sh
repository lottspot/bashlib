# print arguments as a series of lines
# useful for printing arrays as lines`
join_lines()
{
    local IFS=$'\n'
    printf '%s\n' "$*"
}

# trim leading and trailing whitespace
# from a string
trim()
{
    s=$1
    [[ $s =~ ^[[:space:]]*(.*[^[:space:]])[[:space:]]*$ ]]
    printf '%s' "${BASH_REMATCH[1]}"
}
