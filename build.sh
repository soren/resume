#!/bin/bash

source="cv.tex kompetencer.tex cv.en.tex"
output="output"
public="public"

mkdir -p $output $public

for file in $source; do
    git log -1 --format="%ai" $file | cut -c-16 > $output/${file}.ts
    pdflatex -output-dir $output $file && cp $output/${file%tex}pdf $public
done

public_html_conf=public_html.in

if [[ -f $public_html_conf ]]; then
    (cd $public && cp ${source//.tex/.pdf} $(<../$public_html_conf))
fi
