#!/bin/bash

# actually do this
fake=0

start_dir="."

# usually it starts at 0 and we want 1 for Plex
offset=1
# take in flags

while getopts d:b:s:f:o: flag
do
    case "${flag}" in
	d) start_dir=${OPTARG};;
        b) basename=${OPTARG};;
        s) season=${OPTARG};;
        f) fake=${OPTARG};;
	o) offset=${OPTARG};;
    esac
done

#echo $basename
#echo $season
#echo $fake
#echo $offset
# look at all the mkvs with the standard MakeMKV format name

if [ $fake -eq 1 ]; then
	mkdir -p "$start_dir/test"
fi

for file in $start_dir/title_t*.mkv; do
  # Extract NN (2-digit number)
  NN=$(echo "$file" | grep -oP '(?<=title_t)\d{2}')
  
  # Calculate MM
  MM=$(printf "%02d" $(expr $NN + $offset))
  
  # Construct new filename
  new_name="$basename - S${season}E$MM.mkv"
  #echo $fake  
  if [ $fake -eq 1 ]; then
	  touch "$start_dir/test/$new_name"
  else
  # Rename the file
  mv "$file" "$start_dir/$new_name"

  fi
done

