#!/usr/bin/env bash

# md2pdf filename title author date

infile=$1
filename=$(basename -- "$infile")
rootname="${filename%%.*}"

thisdir=`dirname "$0"`

author=${3:-"Ralph W. Crosby, PhD."}
date=${4:-`date`}

config=${md2pdf_config:-$thisdir/Md2PdfPandocConfig.yaml}
template=${md2pdf_template:-$thisdir/md2pdf.pandoc.template}


if [ -v 2 ] ; then
       pandoc -V date="$date" \
              -V author="$author" \
              -V title="$2" \
              -o $rootname.pdf \
              --template="$template" \
              --pdf-engine=lualatex \
              "$config" \
              $infile 
else
       pandoc -V date="$date" \
              -V author="$author" \
              -o $rootname.pdf \
              --template="$template" \
              --pdf-engine=lualatex \
              "$config" \
              $infile 
fi

