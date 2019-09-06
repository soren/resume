#!/bin/bash

function usage {
    echo -e "Usage: $0 <action> [-d <public dir>] [-n]\n\nWhere <action> is one of\n"
    for valid_action in ${valid_actions//[><]/ }; do echo "    $valid_action"; done
    echo -e "\nand\n"
    echo "    -d <public dir> sets the directory where the resulting PDFs are stored";
    echo "    -n              performs a dry run"

    echo
}

function run {
    echo "[CMD] $*"
    $dry_run || $*
}

valid_actions="<all><prepare><clean>"

if [[ $# -gt 0 && ${1:0:1} != "-" ]]; then
    action="$1"
    shift
else
    action="all"
fi

if [[ "${valid_actions/<$action>}" == "$valid_actions" ]]; then
    echo -e "Unknown action: $action\n"
    usage
    exit 1
fi

while [[ $# -gt 0 ]]; do
    if [[ "$1" == "-p" ]]; then
        if [[ -z "$2" ]]; then usage && exit 1; fi
        public=$2
        shift 2
    elif [[ "$1" == "-n" ]]; then
        dry_run=true
        shift
    else
        echo -e "Unknow option: $1\n"
        usage
        exit 1
    fi
done

source="cv.tex kompetencer.tex cv.en.tex"
output="output"
public="${public:-public}"
dry_run="${dry_run:-false}"

echo "[VAR] public='$public'"
echo "[VAR] dry_run='$dry_run'"

case $action in
    all|prepare)
        run mkdir -p $output $public

        for file in $source; do
            echo "[MSG] Getting modified time of $file"
            if [[ ! -f ${file}.ts ]]; then
                $dry_run && git log -1 --format=%ai $file | cut -c-16  > ${file}.ts
            fi
            if [[ $action == "all" ]]; then
                run pdflatex -output-dir $output $file && run cp $output/${file%tex}pdf $public
            fi
        done

        if [[ $action == "all" ]]; then
            public_html_conf=public_html.in

            if [[ -f $public_html_conf ]]; then
                (run cd $public && run cp ${source//.tex/.pdf} $(<../$public_html_conf))
            fi
        fi
        run ls -l $output $public
        ;;
    clean)
        run rm -fR $output $public
    ;;
esac
