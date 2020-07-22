#!/usr/bin/bash

#Add the path to your wallpaper folder after /home/<user>/

wallpaper_loc="Desktop/Wallpapers/"

user=$(whoami)

#Now, we create a file and use it to create an array that we can use to iterate over the wallpapers
find /home/${user}/${wallpaper_loc} -type f \( -name \*.jpg -o -name \*.png \) > /home/${user}/bin/files.txt
readarray files < /home/${user}/bin/files.txt	
# echo "${files[4]}" #to print all values, put * or @ in the sq brackets

# Now, lets find the length of the array and then we can use the jobs
# Okay, so i couldnt figure out how to maintain persistent variables for the cronjob. One workaround I thought of was exporting the variables to an external file, and overwriting it everytime we reun the script. Lets see how that goes. 

number_of_pics=${#files[@]}
current_index=$(cat /home/${user}/bin/index.txt)

gsettings set org.gnome.desktop.background picture-uri file://${files[$current_index]}

echo "Background changed to ${files[$current_index]}"

if [ $current_index -lt $(( $number_of_pics -1 )) ]; then
	let current_index+=1
else
	let current_index=0
fi
echo $current_index > /home/${user}/bin/index.txt


