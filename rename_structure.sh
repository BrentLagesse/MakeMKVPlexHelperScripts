#!/bin/bash

fake=0

while getopts f: flag
do
    case "${flag}" in
        f) fake=${OPTARG};;
    esac
done




# Store the name of the current directory -- This is the Show Name
CURRENT_DIR=$(basename "$PWD")
echo "Current Directory: $CURRENT_DIR"


SCRIPT_DIR=$( dirname $0 )

echo "Script Directory:  $SCRIPT_DIR"

# Iterate through the first level of subdirectories -- This is the Season Number
for FIRST_LEVEL_DIR in */; do
  # Remove trailing slash to get the directory name
  FIRST_LEVEL_NAME=$(basename "$FIRST_LEVEL_DIR")
  echo "First-level Subdirectory: $FIRST_LEVEL_NAME"
  #assume that title starts with 0 so we need to add 1 to this value to start
  EPISODES_PROCESSED=1   
  if [[ "$FIRST_LEVEL_NAME" =~ ^[0-9]+$ ]]; then
#    echo "Directory name is an integer"
 
  # Iterate through the second level of subdirectories
  for SECOND_LEVEL_DIR in "$FIRST_LEVEL_DIR"*/; do
    # Remove trailing slash to get the directory name -- This is the Disc Number
    SECOND_LEVEL_NAME=$(basename "$SECOND_LEVEL_DIR")
    echo "  Second-level Subdirectory: $SECOND_LEVEL_NAME"
  if [[ "$SECOND_LEVEL_NAME" =~ ^[0-9]+$ ]]; then
#    echo "Directory name is an integer:"
	largest_file=$(find "./$SECOND_LEVEL_DIR/" -maxdepth 1 -type f -name "*.mkv" -exec du -b {} + | sort -n -r | head -n 1)
      #  echo "$largest_file"
	  # Extract the size 
	  largest_size=$(echo "$largest_file" | awk '{print $1}')
          # Usually you have like 5-6 episodes on a disc, but sometimes there are extras that aren't as big.  Lets assume that we want to remove the extras for the time being as they usually aren't handled the same way as the rest by the movie databases/plex.
	  filter_size=$((largest_size / 4))
	 # echo "$filter_size"
	 COMMAND="$SCRIPT_DIR/move_small.sh -d ./$SECOND_LEVEL_DIR -s $filter_size" 
	 CLEAN_COMMAND=${COMMAND//[![:print:]]/}
         #echo $CLEAN_COMMAND
	 bash $CLEAN_COMMAND

	COMMAND="$SCRIPT_DIR/rename_and_renumber.sh -d ./$SECOND_LEVEL_DIR -b $CURRENT_DIR -s $FIRST_LEVEL_NAME -f $fake -o $EPISODES_PROCESSED"
        echo $COMMAND
	bash $COMMAND

	mkv_count=$(find "./$SECOND_LEVEL_DIR" -maxdepth 1 -type f -name "*.mkv" | wc -l)

	EPISODES_PROCESSED=$((EPISODES_PROCESSED + mkv_count))


	 # echo "$largest_size"
	 # file_name=$(echo "$largest_file" | awk '{print $2}')
    fi

  done
  fi
done

