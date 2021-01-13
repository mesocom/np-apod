#!/bin/zsh

# Written by Nick Perlaky 2020
#
# Grabs NASA APOD image or YouTube thumbnail, ideally for use as a desktop background.
#
# On MacOS, for exmaple, one would set the desktop to change images every minute
# to ensure this image is seen as soon as the job is run.
#
# The script will exit and retain the last image if no thumbnail or image can be extracted.


cd "/working/directory"

imagePath=$(curl -s https://apod.nasa.gov/apod/astropix.html | grep "<a" | grep -o '"image.*"' | sed 's/"//g')

if [[ "$imagePath" == "" ]]
then
	imagePath=$(curl -s https://apod.nasa.gov/apod/astropix.html | grep "iframe")
	videoID=$(echo "${${imagePath#*embed/}%?rel*}")
	[[ "$videoID" == "" ]] && exit
	rm -f *.jpg
	rm -f *.png
	rm -f *.jpeg
	rm -f *.tmp
	wget -q https://i3.ytimg.com/vi/$videoID/maxresdefault.jpg
else
	apodURL=$(cat <(echo https://apod.nasa.gov/) <(echo $imagePath) | tr -d '\n')
	rm -f *.jpg
	rm -f *.png
	rm -f *.jpeg
	rm -f *.tmp 
	wget -q --accept png,jpg,jpeg $apodURL
fi

