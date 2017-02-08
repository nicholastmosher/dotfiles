hook global BufCreate .*\.als %{
    set buffer filetype alloy
}

addhl -group / regions -default code alloy \
    string %{(?<!')"} %{(?<!\\)(\\\\)*"} '' \
    comment /\* \*/ '' \
    comment // $ ''

addhl -group /alloy/string fill string
addhl -group /alloy/comment fill comment

addhl -group /alloy/code regex %{\b(this|true|false|null)\b} 0:value
addhl -group /alloy/code regex "\b(let|all|no|some|lone|one|sum|disj|not|in|sig|pred|assert|run|for|but|assert|check|open|enum|abstract|fact|extends)\b" 0:keyword

hook -group alloy-highlight global WinSetOption filetype=alloy %{ addhl ref alloy }
hook -group alloy-highlight global WinSetOption filetype=(?!alloy).* %{ rmhl alloy }
