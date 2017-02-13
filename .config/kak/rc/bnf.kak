hook global BufCreate .*/?[gG]rammar %{
    set buffer filetype bnf
}

addhl -group / regions -default content bnf \
    comment '#' '$' '' \
    semantic '%%%' '%%%' ''

addhl -group /bnf/comment fill comment
addhl -group /bnf/semantic ref java

addhl -group /bnf/content regex "(skip)" 1:keyword
addhl -group /bnf/content regex "\s+(::=|\*\*=)\s+" 1:operator
addhl -group /bnf/content regex ^%$ 0:operator
addhl -group /bnf/content regex "\b[A-Z][A-Z0-9]+\b" 0:variable
addhl -group /bnf/content regex "('[^']+?')" 1:string
addhl -group /bnf/content regex "\b(<[A-Z][A-Z0-9]+>)\b" 1:attribute
addhl -group /bnf/content regex "(<[a-z][a-zA-Z]*>)" 1:type
addhl -group /bnf/content regex "(<[a-z][a-zA-Z]*>):([a-zA-Z]+)" 2:attribute

hook -group bnf-highlight global WinSetOption filetype=bnf %{ addhl ref bnf }
hook -group bnf-highlight global WinSetOption filetype=(?!bnf).* %{ rmhl bnf }
