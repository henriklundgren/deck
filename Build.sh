#!/bin/bash

# @author Henrik Lundgren
# @date 2014-01-23

# Variables
temp=tmp
dist=dist/xfwm4
src=src/theme.xcf

# Arrays
framesActive=('bottom-active' 'bottom-left-active' 'left-active' 'top-left-active' 'title-1-active' 'title-2-active')
framesInactive=('bottom-inactive' 'bottom-left-inactive' 'left-inactive' 'top-left-inactive' 'title-1-inactive' 'title-2-inactive')
titles=('title-3-active' 'title-3-inactive')
buttons=('active' 'pressed')
signs=('close' 'hide' 'maximize' 'menu' 'shade' 'stick')

echo 'Welcome to Deck theme creator'
echo 'I require xcftools to process GIMP xcf file format and Imagemagick to process the rest of the steps.'

read -p 'Press [ENTER] to continue...'
clear

xcfinfo $src

read -p 'Press [ENTER] to continue...'
clear

# remove old (should first check if they exist I guess)
rm -r $temp
rm -r $dist

# create
mkdir $temp
mkdir -p $dist


# Base frame active
########################

for frame in ${framesActive[@]}
do
  # Extract xpm
  xcf2png -vC $src "$frame".xpm -o $temp/"$frame".xpm.temp

  # Convert PNG to XPM
  convert $temp/"$frame".xpm.temp +map $temp/"$frame".xpm

  # Remove unused for now only (later we only remove the entire folder)
  #rm $temp/"$frame".xpm.temp
done

for frame in ${framesInactive[@]}
do
  # Extract xpm
  xcf2png -vC $src "$frame".xpm -o $temp/"$frame".xpm.temp

  # Convert PNG to XPM
  convert $temp/"$frame".xpm.temp +map $temp/"$frame".xpm

  # Remove unused for now only (later we only remove the entire folder)
  #rm $temp/"$frame".xpm.temp
done

for val in ${framesActive[@]}
do
  # Skip bottom
  if [ "$val" = "bottom-active" ]
  then
    continue
  elif [ "$val" = "title-2-active" ] # title-2-active
  then
    convert $temp/"$val".xpm -flop $temp/${val/2/4}.xpm
  elif [ "$val" = "title-1-active" ]
  then
    convert $temp/"$val".xpm -flop $temp/${val/1/5}.xpm
  else
    convert $temp/"$val".xpm -flop $temp/${val/left/right}.xpm
  fi
done

for vall in ${framesInactive[@]}
do
  # Skip bottom
  if [ "$vall" = "bottom-inactive" ]
  then
    continue
  elif [ "$vall" = "title-2-inactive" ]
  then
    convert $temp/"$vall".xpm -flop $temp/${vall/2/4}.xpm
  elif [ "$vall" = "title-1-inactive" ]
  then
    convert $temp/"$vall".xpm -flop $temp/${vall/1/5}.xpm
  else
    convert $temp/"$vall".xpm -flop $temp/${vall/left/right}.xpm
  fi
done

ls --ignore=*.temp $temp
read -p 'Base frame is done. Press [RETURN] to continue...'



# Overlay frame
#########################

for frame in ${framesActive[@]}
do
  # Extract
  xcf2png -vCA $src "$frame".png -o $temp/"$frame".png.temp
done

for frame in ${framesInactive[@]}
do
  # Extract
  xcf2png -vCA $src "$frame".png -o $temp/"$frame".png.temp
done

for val in ${framesActive[@]}
do
  if [ "$val" = "bottom-active" ]
  then
  convert $temp/"$val".png.temp -channel Alpha -evaluate Divide 2 png32:$temp/"$val".png
  elif [ "$val" = "title-2-active" ]
  then
    convert $temp/"$val".png.temp -flop -channel Alpha -evaluate Divide 2 png32:$temp/${val/2/4}.png
  elif [ "$val" = "title-1-active" ]
  then
    convert $temp/"$val".png.temp -flop -channel Alpha -evaluate Divide 2 png32:$temp/${val/1/5}.png
  else
    convert $temp/"$val".png.temp -flop -channel Alpha -evaluate Divide 2 png32:$temp/${val/left/right}.png
  fi

  # Add opacity
  convert $temp/"$val".png.temp -channel Alpha -evaluate Divide 2 png32:$temp/"$val".png
done

for val in ${framesInactive[@]}
do
  if [ "$val" = "bottom-inactive" ]
  then
  convert $temp/"$val".png.temp -channel Alpha -evaluate Divide 2 png32:$temp/"$val".png
  elif [ "$val" = "title-2-inactive" ]
  then
    convert $temp/"$val".png.temp -flop -channel Alpha -evaluate Divide 2 png32:$temp/${val/2/4}.png
  elif [ "$val" = "title-1-inactive" ]
  then
    convert $temp/"$val".png.temp -flop -channel Alpha -evaluate Divide 2 png32:$temp/${val/1/5}.png
  else
    convert $temp/"$val".png.temp -flop -channel Alpha -evaluate Divide 2 png32:$temp/${val/left/right}.png
  fi

  # Add opacity
  convert $temp/"$val".png.temp -channel Alpha -evaluate Divide 2 png32:$temp/"$val".png
done

ls --ignore=*.temp $temp
read -p 'Overlay frame is done. Press [RETURN] to continue...'
clear

# Title plate
#################

for title in ${titles[@]}
do
  xcf2png -vC   $src  "$title".xpm    -o $temp/"$title".xpm.temp
  xcf2png -vCA  $src  "$title".png    -o $temp/"$title".png.temp

  convert $temp/"$title".xpm.temp  +map  $temp/"$title".xpm
  convert $temp/"$title".png.temp -channel Alpha -evaluate Divide 2 png32:$temp/"$title".png
done

ls --ignore=*.temp $temp
read -p 'Title plate is done. Press return...'
clear

# Buttons // active, pressed
#################
for button in ${buttons[@]}
do
  # xpm
  xcf2png -vC   $src "$button".xpm  -o $temp/"$button".xpm.temp
  # png
  xcf2png -vCA  $src "$button".png  -o $temp/"$button".png.temp

  # Convert to xpm // Use this to merge with sign
  convert $temp/$button.xpm.temp    +map  $temp/$button.xpm

  # Add opacity to overlay
  convert $temp/"$button".png.temp -channel Alpha -evaluate Divide 2 png32:$temp/"$button".png

  # Move to directory remove later
  #rm $temp/"$button".png.temp
  #rm $temp/"$button".xpm.temp
done

# Get the signs // close, maximize, menu, stick, hide
for sign in ${signs[@]}
do
  xcf2png -vC $src "$sign".png -o $temp/"$sign".png.temp

  # Merge images
  composite $temp/"$sign".png.temp  $temp/active.xpm    $temp/"$sign"-active.xpm
  composite $temp/"$sign".png.temp  $temp/pressed.xpm   $temp/"$sign"-pressed.xpm

  # png
  cp $temp/active.png $temp/"$sign"-active.png
  cp $temp/pressed.png $temp/"$sign"-pressed.png

  #rm $temp/active.png $temp/active.xpm $temp/pressed.png $temp/pressed.xpm
done

ls --ignore=*.temp $temp
read -p 'The buttons should be ready. Press return...'
clear

echo 'I will prepare dist and remove temp directory.'
rm $temp/active.png $temp/active.xpm $temp/pressed.xpm $temp/pressed.png

# Prepare dist
##############
cp $temp/*.xpm $dist
cp $temp/*.png $dist
cp src/themerc $dist

ls $dist

read -p 'Theme should be build now.'

