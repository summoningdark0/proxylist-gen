#!bin/bash


#script uses imagemagick
# not tested with png
#not tested with cmyk

# . is a current directory
# change it to whatever you need
directory="."
imageArray=("$directory"/*.jpg)
imageCount=${#imageArray[@]}
cardX=731
cardY=1037
length=80
padding=20
marginLeft=143
marginRight=143	
marginTop=198
marginBottom=198



processImage () {
	magick $1 -gravity center -background "$(magick $1 -adaptive-resize 1x1 txt:- | grep -o "#[0-9A-Fa-f]\{6\}")" -resize ${cardX}x${cardY} -extent ${cardX}x${cardY} -
}

passNumber=0


for ((i = 0; i < imageCount; i += 9)) do
	imageLeft=$((imageCount - i))
	imageMontage=$((imageLeft > 9 ? 9 : imageLeft))

	imageBuild=()
	for ((j=0; j<imageMontage; j++)); do
		index=$((i + j))
		imageBuild+=("<(processImage \"${imageArray[$index]}\")")
	done

	# builds a temp
	tempBuild="temp_pass_${passNumber}.jpg"
	eval montage "${imageBuild[@]}" -tile 3x3 -geometry +0+0 "${tempBuild}"
	
    
	#left margin + canvas + spacing between canvas
	#this is the starting left x that is fixed for all left 
	leftStart=$((marginLeft - (length + padding))) 

	#starting top y, same 
	topStart=$((marginTop - (length + padding)))

	#srarting right x, same
	rightStart=$((marginRight + cardX*3 + padding))

	#starting bottom y, same
	bottomStart=$((marginTop + cardY*3 + padding))
	
	drawLines=()
	#left
	for ((k=0; k<4; k++)); do
 			drawLines+=("-draw \"line $leftStart,$((marginTop+cardY*k)) $((leftStart+length)),$((marginTop+cardY*k))\"")
 	done

 	#right
 	for ((k=0; k<4; k++)); do
 			drawLines+=("-draw \"line $rightStart,$((marginTop+cardY*k)) $((rightStart+length)),$((marginTop+cardY*k))\"")
 	done

 	#top 
 	for ((k=0; k<4; k++)); do
 			drawLines+=("-draw \"line $((marginLeft+cardX*k)),$topStart $((marginLeft+cardX*k)),$((topStart+length))\"")
 	done

 	#top 
 	for ((k=0; k<4; k++)); do
 			drawLines+=("-draw \"line $((marginLeft+cardX*k)),$bottomStart $((marginLeft+cardX*k)),$((bottomStart+length))\"")
 	done
	

	eval magick "${tempBuild}" -extent 2480x3508-"${marginLeft}"-"${marginTop}" -strokewidth 2 -stroke black "${drawLines[@]}" "Page_${passNumber}.jpg"
	rm $tempBuild
	((passNumber++))
done


