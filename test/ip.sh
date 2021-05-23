. "$SRC_ROOT/ip.sh"

enter_suite()
{
    local ip4=192.168.86.1
    local ip4_cidrmask=24
    local ip6=2601:80:c241:af40:d6e2:9113::d606
    local ip6_prefix=81

    test_set_func 'ip42hex'
    local ip4_hex=$(ip42hex "$ip4")
    test_print info "ip4 addr: $ip4/$ip4_cidrmask"
    test_print info "ip4 hex : $(printf '%s' $ip4_hex)"

    test_set_func 'ip4_prefix'
    local ip4_pfxbits=$(ip4_prefix $ip4_hex $ip4_cidrmask)
    test_print info "ip4 addr: $ip4/$ip4_cidrmask"
    test_print info "ip4 pfx : $(printf '%s' $ip4_pfxbits)"

    test_set_func 'ip62hex'
    local ip6_hex=$(ip62hex "$ip6")
    test_print info "ip6 addr: $ip6/$ip6_prefix"
    test_print info "ip6 hex : $(printf '%s' $ip6_hex)"

    test_set_func 'ip6_prefix'
    local ip6_pfxbits=$(ip6_prefix $ip6_hex $ip6_prefix)
    test_print info "ip6 addr: $ip6/$ip6_prefix"
    test_print info "ip6 pfx : $(printf '%s' $ip6_pfxbits)"
}
