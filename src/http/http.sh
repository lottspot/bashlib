# send an http POST request with data
# provided from kv store.
# uses/stores cookies.
# data args should be in the form:
# {param_name}={kv_data_key}
http_rq_post()
{
    local endpoint=$1
    local method=POST
    local param_name=
    local param_key=
    local args=()
    shift

    for param in "$@"; do
        IFS=$'=' read param_name param_key <<< $param
        args+=( '--data-urlencode' "$param_name=$(kv $param_key)" )
    done

    http_rq_session "${args[@]}" -X "$method" "$endpoint"
}

http_rq_session()
{
    http_rq -b <(echo "$(kv http:cookies)") -c >(kv http:cookies "$(cat)") "$@"
}

http_rq()
{
    curl -s -D >(kv http:resp:headers "$(cat)") "$@"
    http_resp_parse
}

http_resp_parse()
{
    # Clear old parse results
    kv_purge 'http:resp:headers:*'

    local i=1
    while read line; do
        test -n "$line" || continue
        if [ $i -eq 1 ]; then
            local proto=
            local code=
            local msg=
            read proto code msg <<< $line
            kv http:resp:status:proto  "$proto"
            kv http:resp:status:code   "$code"
            kv http:resp:status:msg    "$msg"
        else
            local headname=$(trim "${line%%:*}")
            local headval=$(trim "${line#*:}")
            kv "http:resp:headers:$headname" "$headval"
        fi
        ((i++))
    done < <(kv http:resp:headers)
}

http_resp_header()
{
    local name=$1
    kv "http:resp:headers:$name"
}

http_resp_status()
{
    local part=$1

    if [ -n "$part" ]; then
        kv "http:resp:status:$part"
    else
        printf '%s %s %s' \
            "$(kv http:resp:status:proto)"   \
            "$(kv http:resp:status:code)"    \
            "$(kv http:resp:status:msg)"
    fi
}
