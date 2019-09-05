#!/bin/bash
for file in cv.tex kompetencer.tex cv.en.tex; do
    date --date "$(git 2>/dev/null log $file|head -n3|awk '/^Date:/{print $2,$3,$4,$5,$6}')" +"%F %H:%M" > ${file}.ts
    pdflatex $file
    cp ${file%tex}pdf public/
done
