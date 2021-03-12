#!/usr/bin/env bash

# md2pdf filename title author date

infile=$1
filename=$(basename -- "$infile")
rootname="${filename%%.*}"

thisdir=`dirname "$0"`

title=$2
# author=${3:-"Ralph W. Crosby, PhD."}
author=$3
date=${4:-`date`}

config=${md2pdf_config:-$thisdir/md2pdf.pandoc.config.yaml}
template=${md2pdf_template:-$thisdir/md2pdf.pandoc.template}
shortener=${md2pdf_shortener:-$thisdir/md2pdf.shorten.filename.py}

# Build the command options
opts="-M date=\"$date\""
# opts=$opts" -M author=\"$author\""
[[ "x$author" != "x" ]] && opts=$opts" -M author=\"$author\""
[[ "x$title" != "x" ]] && opts=$opts" -M title=\"$title\""
opts=$opts" -M dispfilename=\"$($shortener -m 50 "$infile" )\""
opts=$opts" --template=\"$template\""
opts=$opts" --pdf-engine=lualatex"

# First run to create the .pdf
eval pandoc $opts \
       -o \"$rootname.pdf\" \
       "$config" \
       \"$infile\" 

rc=$?

# If it failed, generate the .tex outout
if [[ $rc -ne 0 ]]; then
       echo "Creating .tex output on error"
       eval pandoc "$opts" \
              -s \
              -o \"$rootname.tex\" \
              "$config" \
              \"$infile\" 

fi