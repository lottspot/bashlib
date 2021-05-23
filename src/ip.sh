
ip42hex()
{
    local ip4=$1
    local octets=()
    IFS=. octets+=($ip4)
    printf '0x%0.2x%0.2x%0.2x%0.2x' "${octets[@]}"
}

ip62hex(){
    local ip6=$1
    local hextets=()
    IFS=: hextets+=($ip6)
    local hextets_want=8
    local hextets_have=${#hextets[*]}
    local output=
    for (( i=0; i<$hextets_have; i++ )); do
        local hextet=${hextets[$i]}
        if [ -z "$hextet" ]; then  # longest 0000s run
            local zero_fillcount=$(( ($hextets_want-$hextets_have+1)*4 ))
            output+="$(printf "%0.${zero_fillcount}d" 0)"
        else
            output+="$(printf '%0.4x' 0x$hextet)"
        fi
    done
    printf '0x%s' "$output"
}

# takes two args in the form $ipaddr $cidrmask
# and returns the prefix portion of the address
# $ipaddr must be an int as returned by ip42hex
ip4_prefix()
{
    local addr=$1
    local cidrmask=$2

    printf "0x%0.$(( addr_space/4 ))x" $(($addr>>(32-$cidrmask)<<(32-$cidrmask) ))
}

# takes two args in the form $ipaddr $prefix
# and returns the prefix portion of the address
# $ipaddr must be in the form returned by ip62hex
ip6_prefix()
{
    local addr=$1
    local pfx=$2

    local addr=${addr#*x} # strip leading 0x
    local n_nibbles=$(( pfx/4 ))
    local lastnibble_mask=$(( pfx%4 ))
    local lastnibble=
    local pfxstr=

    pfxstr=${addr:0:$n_nibbles}

    if [ $lastnibble_mask -gt 0 ]; then  # prefix includes partial nibble
        lastnibble="${addr:$n_nibbles:1}"
        pfxstr+="$(( 0x$lastnibble>>4-lastnibble_mask<<4-lastnibble_mask ))"
    fi

    # backfill 0 bits in prefix str
    local zero_fillcount=$(( ${#addr}-${#pfxstr} ))
    pfxstr+=$(printf "%0.${zero_fillcount}d" 0)
    printf '0x%s' "$pfxstr"
}
