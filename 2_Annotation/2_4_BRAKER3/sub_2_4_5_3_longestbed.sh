#!/usr/bin/bash
#from file specified by first argument, gets the longest bed entry from the file...
largest_difference=$(awk '{ diff = $5 - $6; if (diff < 0) diff = -diff; if (diff > max_diff) { max_diff = diff; max_line = NR; }} END { print max_line }' "$1")

#...and outputs this to SDOUT
awk -v line="$largest_difference" 'NR == line' "$1"
