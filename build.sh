#!/bin/bash

sources="cv.tex kompetencer.tex cv.en.tex"

mkdir -p output/ public/

for file in $sources; do
    date --date "$(git 2>/dev/null log $file|head -n3|awk '/^Date:/{print $2,$3,$4,$5,$6}')" +"%F %H:%M" > output/${file}.ts
    pdflatex -output-dir output/ $file
    (cd public && ln -fs ../output/${file%tex}pdf .)
done

if [[ -f public_html.in ]]; then
    (cd public && cp ${sources//.tex/.pdf} $(<../public_html.in))
fi
