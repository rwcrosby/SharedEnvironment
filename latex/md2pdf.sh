#!/bin/bash

# md2pdf filename title author date

infile=$1
filename=$(basename -- "$infile")
rootname="${filename%%.*}"

thisdir=`dirname "$0"`

title=${2:-$filename}
author=${3:-"Ralph W. Crosby, PhD."}
date=${4:-`date`}
config=${md2pdf_config:-$thisdir/Md2PdfPandocConfig.yaml}

pandoc -V title="$title" \
       -V date="$date" \
       -V author="$author" \
       -o $rootname.pdf \
       "$config" \
       $infile