#!/bin/bash

# actually do this
fake=0

# usually it starts at 0 and we want 1 for Plex
offset=1
# take in flags

while getopts b:s:f:o: flag
do
    case "${flag}" in
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
	mkdir test
fi

for file in title_t*.mkv; do
  # Extract NN (2-digit number)
  NN=$(echo "$file" | grep -oP '(?<=title_t)\d{2}')
  
  # Calculate MM
  MM=$(printf "%02d" $(expr $NN + $offset))
  
  # Construct new filename
  new_name="$basename - S${season}E$MM.mkv"
  echo $fake  
  if [ $fake -eq 1 ]; then
	  touch "test/$new_name"
  else
  # Rename the file
  mv "$file" "$new_name"

  fi
done

