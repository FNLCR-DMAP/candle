#!/bin/bash

images_dir=$1
filter=$2
ncol=$3
prefix=$4

# Write the table of images
echo "<table border=1>"
icol=1
echo "  <tr>"
iimg=1
#nimg=$(find "$images_dir" -type f | wc -l)
nimg=$(find "$images_dir" -type f -name "$prefix\*" | wc -l)
#for image in "${images_dir}"/*; do
for image in "${images_dir}"/${prefix}*; do
    image_name=$(basename "$image")
    echo -e "    <td align=\"center\">${image_name}\n<img src=\"images-${filter}/${image_name}\"></td>"
    if [ "$iimg" -lt "$nimg" ]; then
        if [ "$icol" -lt "$ncol" ]; then
            icol=$((icol+1))
        else
            echo "  </tr>"
            icol=1
            echo "  <tr>"
        fi
        iimg=$((iimg+1))
    else
        echo "  </tr>"
    fi
done
echo "</table>"
