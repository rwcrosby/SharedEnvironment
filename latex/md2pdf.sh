#!/usr/bin/env bash

thisdir=`dirname "$0"`
output="pdf"

# Process the options

while getopts 't:' OPTION; do
  case "$OPTION" in
    t)
      output="$OPTARG"
      ;;
    ?)
      echo "Usage: $(basename $0) [-t docx|tex] infile [title] [author] [date]"
      echo "  To override the pandoc configuration, pandoc template, or filename shortner use"
      echo "    md2pdf_config=<config file>"
      echo "    md2pdf_template=<template file>"
      echo "    md2pdf_shortener=<filename shortener>"
      exit 1
      ;;
  esac
done

shift "$(($OPTIND -1))"

infile=$1
filename=$(basename -- "$infile")
rootname="${filename%%.*}"

title=$2
author=${3:-"Ralph W. Crosby, PhD."}
date=${4:-`date +'%d-%b-%Y %T'`}

# Setup the configuration

config=${md2pdf_config:-$thisdir/Default_PandocConfig.yaml}
template=${md2pdf_template:-$thisdir/md2pdf.template}
shortener=${md2pdf_shortener:-$thisdir/ShortenFilename.py}

# echo "Config: $config"
# echo "Template: $template"
# echo "Shortener: $shortener"

# Build the command options

opts="-M date=\"$date\""
[[ "x$author" != "x" ]] && opts=$opts" -M author=\"$author\""
[[ "x$title" != "x" ]] && opts=$opts" -M title=\"$title\""
opts=$opts" -M dispfilename=\"$($shortener -m 50 "$infile" )\""
opts=$opts" --template=\"$template\""
opts=$opts" --pdf-engine=lualatex"

# Attempt to create the requested target

eval pandoc $opts \
      -s \
      -o \"$rootname.$output\" \
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
  exit 1
fi
