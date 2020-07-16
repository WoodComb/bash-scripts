#!/usr/bin/bash

#First, we define the user and then the input and output variables

if [ -z $1 ]; then #-z is a bash option to check if parameter $1 has any value
	user=$(whoami)
else
	if [ ! -d "/home/${1}" ]; then #-d tells if directory exists
		echo "No directory named ${1} exists in the home directory"
		exit 1 #we can exit with 0 or 1; 1 means we exited with error and 0 means without
	fi
	user=$1
fi



input=/home/${user}
output=/home/${user}/Desktop/${user}_$(date +%Y-%m-%d_%H.%M.%S.tar.gz)

#Now, write the functions for counting files before, after, and to compress

function input_files_no {
	find $1 -type f | wc -l
}

function input_dirs_no {
	find $1 -type d | wc -l
}

function compress {
	tar -czf $2 $1 2> /dev/null
}

function output_files_no {
	tar -tzf $1 | grep -v /$ | wc -l
}

function output_dirs_no {
	tar -tzf $1 | grep /$ | wc -l
}

# Now, we execute the backup process

input_files=$( input_files_no $input )
input_dirs=$( input_dirs_no $input )
echo "Files to archive: $input_files"
echo "Directories to archive: $input_dirs"

compress $input $output

output_files=$( output_files_no $output )
output_dirs=$( output_dirs_no $output )
echo "Archived files: $output_files"
echo "Archived directories: $output_dirs"

# We can also add a sanity check to see if all the files were archived

if [ $input_files -eq $output_files ]; then
	echo "Backup of $input successfully completed!"
	echo "Details of backup file:"
	ls -l $output
else
	echo "Backup of $input failed."
fi
