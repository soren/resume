#!/bin/bash

if [[ $# -eq 0 ]]; then
    action=all
else
    [[ "$1" == "prepare" || "$1" == "clean" ]] && action=$1
fi

source="cv.tex kompetencer.tex cv.en.tex"
output="${OUTPUT_DIR:-output}"
public="${PUBLIC_DIR:-public}"

if [[ $action != "clean" ]]; then
    mkdir -p $output $public

    for file in $source; do
        if [[ ! -f $output/${file}.ts ]]; then
            git log -1 --format="%ai" $file | cut -c-16 > $output/${file}.ts
        fi
        if [[ $action == "all" ]]; then
            pdflatex -output-dir $output $file && cp $output/${file%tex}pdf $public
        fi
    done

    if [[ $action == "all" ]]; then
        public_html_conf=public_html.in

        if [[ -f $public_html_conf ]]; then
            (cd $public && cp ${source//.tex/.pdf} $(<../$public_html_conf))
        fi
    fi
else
    rm -fR $output $public
fi
