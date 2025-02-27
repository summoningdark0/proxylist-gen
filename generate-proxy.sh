#!/opt/local/bin/bash


#script uses imagemagick
# not tested with png
#not tested with cmyk

# . is a current directory
# change it to whatever you need

# printf "\e[1;91;40mStage 1\e[0m\n"

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

unset jpgFiles
unset pngFiles


# imageArray=("$directory"/*.jpg "$directory"/*.png)


imageCount=${#imageArray[@]}
cardX=731
cardY=1037
length=80
padding=20
marginLeft=143
marginRight=143	
marginTop=198
marginBottom=198

# printf "\e[1;91;40mStage 2\e[0m\n"

processImage () {
	cardBGColor=$(magick "$1" -adaptive-resize 1x1 txt:- | grep -o "#[0-9A-Fa-f]\{6\}")
	magick "$1" -gravity center -background ${cardBGColor} -resize ${cardX}x${cardY} -extent ${cardX}x${cardY} -
}
# printf "\e[1;91;40mStage 3\e[0m\n"


#"/Users/summoningdark/Documents/Netrunner/cards/proxy generator/proxylist-gen/ENLIB/30119.jpg"

# magick "/Users/summoningdark/Documents/Netrunner/cards/proxy generator/proxylist-gen/ENLIB/30119.jpg" -gravity center -background "$(magick \"/Users/summoningdark/Documents/Netrunner/cards/proxy generator/proxylist-gen/ENLIB/30119.jpg\" -adaptive-resize 1x1 txt:- | grep -o "#[0-9A-Fa-f]\{6\}")" -resize ${cardX}x${cardY} -extent ${cardX}x${cardY} -
date="$(date "+%H%M")"
passNumber=0
# printf "\e[1;91;40mStage 4\e[0m\n"

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
#error
	#printf "${imageBuild[1]}\nAAAA\n"
	#printf "${tempBuild}\n"
	printf "\e[1mBuilding page %s…\e[0m\n" "$passNumber"
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
	

	eval magick "${tempBuild}" -extent 2480x3508-"${marginLeft}"-"${marginTop}" -strokewidth 2 -stroke black "${drawLines[@]}" "${outputDirectory}/\"${date}\"-Page-${passNumber}.jpg"
	rm $tempBuild
	((passNumber++))
done


printf "\e[1;92;40mDone.\e[0m\n"

