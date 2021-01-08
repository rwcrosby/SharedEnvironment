#!/usr/bin/env bash

# md2pdf filename title author date

infile=$1
filename=$(basename -- "$infile")
rootname="${filename%%.*}"

thisdir=`dirname "$0"`

title=$2
author=${3:-"Ralph W. Crosby, PhD."}
date=${4:-`date`}

config=${md2pdf_config:-$thisdir/Md2PdfPandocConfig.yaml}
template=${md2pdf_template:-$thisdir/md2pdf.pandoc.template}

# Build the command options
opts="-V date=\"$date\""
opts=$opts" -V author=\"$author\""
[[ "x$title" != "x" ]] && opts=$opts" -V title=\"$title\""
opts=$opts" --template=\"$template\""
opts=$opts" --pdf-engine=lualatex"

# First run to create the .pdf
eval pandoc $opts \
       -o $rootname.pdf \
       "$config" \
       $infile 

rc=$?

# If it failed, generate the .tex outout
if [[ $rc -ne 0 ]]; then
       echo "Creating .tex output on error"
       eval pandoc "$opts" \
              -s \
              -o $rootname.tex \
              "$config" \
              $infile 

fi