#!/usr/bin/bash
#from file specified by first argument, gets the longest bed entry from a file...hang on...
largest_difference=$(awk '{ diff = $5 - $6; if (diff < 0) diff = -diff; if (diff > max_diff) { max_diff = diff; max_line = NR; }} END { print max_line }' "$1")

# Output the line with the largest difference
awk -v line="$largest_difference" 'NR == line' "$1"
