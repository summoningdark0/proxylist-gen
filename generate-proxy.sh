#!/bin/bash


if [ -n "$1" ]; then
	directory=$(realpath "$1")
	else	
		printf "Enter path to directory with images.\nFor directory next to the script just use the folder name or relative path.\nFor current directory leave blank\nDo it: "
		read directory
fi


if [ -n "$directory" ]; then
    if [ -d "$directory" ]; then
        directory=$(realpath "$directory")
        printf "\e[1;92;40mImage directory is set to: %s\e[0m\n" "$directory"
    else
    	printf "\e[1;91;40mDirectory doesn't exist. Rerun script to try again.\e[0m\n"
        exit 1
    fi
else
    directory=$(realpath ".")
    printf "\e[1;92;40mDefaulting to current directory: %s\e[0m\n" "$directory"
fi

outputDirectory="./print-files"
mkdir -p "$outputDirectory"

jpgFiles=("$directory"/*.jpg)
pngFiles=("$directory"/*.png)

if [ -e "${jpgFiles[0]}" ] || [ "${jpgFiles[0]}" != "$directory/*.jpg" ]; then
  imageArray+=("${jpgFiles[@]}")
fi

if [ -e "${pngFiles[0]}" ] || [ "${pngFiles[0]}" != "$directory/*.png" ]; then
  imageArray+=("${pngFiles[@]}")
fi

imageCount=${#imageArray[@]}
cardX=731
cardY=1037
length=80
padding=20
marginLeft=143
marginRight=143	
marginTop=198
marginBottom=198
date="$(date "+%H%M")"

processImage () {
	cardBGColor=$(magick "$1" -adaptive-resize 1x1 txt:- | grep -o "#[0-9A-Fa-f]\{6\}")
	magick "$1" -gravity center -background ${cardBGColor} -resize ${cardX}x${cardY} -extent ${cardX}x${cardY} -
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

	tempBuild="temp_pass_${passNumber}.jpg"

	printf "\e[1mBuilding page %s…\e[0m\n" "$passNumber"
	eval montage "${imageBuild[@]}" -tile 3x3 -geometry +0+0 "${tempBuild}"
	leftStart=$((marginLeft - (length + padding))) 
	topStart=$((marginTop - (length + padding)))
	rightStart=$((marginRight + cardX*3 + padding))
	bottomStart=$((marginTop + cardY*3 + padding))
	
	drawLines=()
	for ((k=0; k<4; k++)); do
 			drawLines+=("-draw \"line $leftStart,$((marginTop+cardY*k)) $((leftStart+length)),$((marginTop+cardY*k))\"")
 	done

 	for ((k=0; k<4; k++)); do
 			drawLines+=("-draw \"line $rightStart,$((marginTop+cardY*k)) $((rightStart+length)),$((marginTop+cardY*k))\"")
 	done

 	for ((k=0; k<4; k++)); do
 			drawLines+=("-draw \"line $((marginLeft+cardX*k)),$topStart $((marginLeft+cardX*k)),$((topStart+length))\"")
 	done

 	for ((k=0; k<4; k++)); do
 			drawLines+=("-draw \"line $((marginLeft+cardX*k)),$bottomStart $((marginLeft+cardX*k)),$((bottomStart+length))\"")
 	done
	

	eval magick "${tempBuild}" -extent 2480x3508-"${marginLeft}"-"${marginTop}" -strokewidth 2 -stroke black "${drawLines[@]}" "${outputDirectory}/\"${date}\"-Page-${passNumber}.jpg"
	rm $tempBuild
	((passNumber++))
done

printf "\e[1;92;40mDone.\e[0m\n"

