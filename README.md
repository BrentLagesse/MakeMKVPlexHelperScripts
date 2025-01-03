# MakeMKV to Plex Helper Scripts

Use at your own risk.  Some shows have extra content that is similar size to real episodes and some shows have double-length episodes, so the naive filter I am using to separate content is a blunt instrument.  I'll try to fix this later.

I wrote these scripts to help make sure Plex could find the TV shows that I ripped from disc.   The scripts go through each directory (assuming the correct directory structure described below), and Identify the show name, the season number, and the disc number.  Then they identify the biggest file in the directory and set a size filter.  This is done because some discs are just episodes and some discs are episodes + extra content.  Typically the extra content is much smaller than the episodes, so I take the biggest file and divide it by 4.  Anything bigger than that is guessed to be an episode and anything else is extra content.   The extra content is moved to a temporary directory that can be dealt with later.  Once we have the episodes, the scripts goes through every disc in a season and renames it.

Use the power shell scripts at your own risk.  I did not write them, I just had ChatGPT generate them from my bash script files.  I do not have a windows machine to test them on.


## Prerequisites

These scripts assume a very specific directory structure.  This was done to make it easier to write the scripts and not have to worry about parsing out strings from integers in Season and Disc numbers.  When you run MakeMKV, you need set your directory structure with the following format.

SHOWNAME/SEASON NUMBER/DISC NUMBER/

For example --

Community/2/1/

Would be the show Community, the second season, and the first disc.

## Usage

I HIGHLY recommend running the script in fake mode first to make sure that it is going to do what you want it to do.

From the directory where you show is located:
bash /path/to/MakeMKVPlexHelperScripts/rename_structure.sh -f 1

This command will test out the script.  If you go into each directory and look for a test directory, you should see some fake files with the names that would have been renamed if you run it for real.
To run it and actually move files, just drop the -f flag and run it like this --

bash /path/to/MakeMKVPlexHelperScripts/rename_structure.sh

For example -- 

**~/$** cd /Videos/Community

**~/Videos/Community/$** bash ~MakeMKVPlexHelperScripts/rename_structure.sh

If you want to change the filter ratio, you can use -s.  Currently it defaults to 2 (which means files smaller than half the largest file get filtered).  3 would be 1/3, etc.   This is a naive approach that I will fix later.
