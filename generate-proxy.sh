#!/opt/local/bin/bash

directory="./proxy"
imageArray=("$directory"/*.jpg)
imageCount=${#imageArray[@]}
declare -i cardX=731
declare -i cardY=1037



processImage () {
	magick $1 -gravity center -background `magick $1 -adaptive-resize 1x1 txt:- | tail -1 | cut -b 27-60` -resize 732x1040 -extent 732x1040 -
}

passNumber=0
for ((i = 0; i < imageCount; i += 9)) do
	imageLeft = $((imageCount - i))
	imageMontage = $((imageLeft > 9 ? 9 : imageLeft))

	imageBuild = ()
	for ((j = 0; j < imageMontage; j++)); do
		index = $((i + j))
		imageBuild+=("<(processImage \"${imageArray[$index]}\")")
	done

	tempBuild="temp_pass_${passNumber}.jpg"



	((passNumber++))
done



convert image.png -background `convert image.png ` 


#identify image at ENLIB/30130.jpg
magick identify ENLIB/30130.jpg

#extract dimensions, third space of output
magick identify ENLIB/30130.jpg | awk '{print $3}'

#extract line contents after first field
awk '{print $(NF>1)}' progfile.txt

#card dimensions for 300dpi print 
#62x88
732x1040

#a4 dimensions 300dpi
2480x3508

#collect proxy lists without borders and marks
magick montage 0[01][1-7].jpg -geometry 732x1039>+0+0 -tile 3x3 +adjoin tile.jpg magick montage 0[01][1-7].jpg -geometry 732x1039>+0+0 -tile 3x3 +adjoin tile.jpg

#compare 2 cards side by side, needs to have the same file name 
magick montage $folder1/$filename $folder2/$filename -geometry 732x1039>+0+0 -tile 2x1 +adjoin E34[01][0-9][0-9].jpg

#montage takes input and runs "-tile 3x3 +adjoin miff:-", :- passes data without saving to disk
#next command takes "-" as input
 magick test.jpg -adaptive-resize 1x1 txt:- | tail -1 | cut -b 27-60
#so the logic is:
#feed an image folder
#
#
#
#
#
#
#
#
#
#


