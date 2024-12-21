#!/bin/bash

for file in title_t*.mkv; do
  # Extract NN (2-digit number)
  NN=$(echo "$file" | grep -oP '(?<=title_t)\d{2}')
  
  # Calculate MM (15 + NN)
  MM=$(printf "%02d" $(expr $NN + 1))
  
  # Construct new filename
  new_name="Community - S01E$MM.mkv"
  
  # Rename the file
  mv "$file" "test/$new_name"
done

