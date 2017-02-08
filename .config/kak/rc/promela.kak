hook global BufCreate .*\.pml %{
    set buffer filetype promela
}

addhl -group / regions -default code promela \
    string %{(?<!')"} %{(?<!\\)(\\\\)*"} '' \
    comment /\* \*/ '' \
    comment // $ '' \
    disabled ^\h*?#\h*if\h+(0|FALSE)\b "#\h*(else|elif|endif)" "#\h*if(def)?" \
    macro %{^\h*?\K#} %{(?<!\\)\n} ""

addhl -group /promela/string fill string
addhl -group /promela/comment fill comment
addhl -group /promela/disabled fill rgb:666666
addhl -group /promela/macro fill meta

addhl -group /promela/code regex "\b(true|false|[\d])\b" 0:value
addhl -group /promela/code regex "\b(byte|chan|mtype|utype)\b" 0:type
addhl -group /promela/code regex "\b(module|proctype|init|never|trace|printf|run|init|inline|break|skip|atomic|ltl|if|else|fi|do|od|for)\b" 0:keyword

hook -group promela-highlight global WinSetOption filetype=promela %{ addhl ref promela }
hook -group promela-highlight global WinSetOption filetype=(?!promela).* %{ rmhl promela }
