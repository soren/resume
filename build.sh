#!/bin/bash

source="cv.tex kompetencer.tex cv.en.tex"
output="output"
public="public"

mkdir -p $output $public

for file in $source; do
    date --date "$(git 2>/dev/null log $file|head -n3|awk '/^Date:/{print $2,$3,$4,$5,$6}')" +"%F %H:%M" > $output/${file}.ts
    pdflatex -output-dir $output $file && cp $output/${file%tex}pdf $public
done

public_html_conf=public_html.in

if [[ -f $public_html_conf ]]; then
    (cd $public && cp ${source//.tex/.pdf} $(<../$public_html_conf))
fi
