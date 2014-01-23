#!/bin/bash

# @author Henrik Lundgren
# @date 2014-01-23

# Variables
temp=tmp
dist=dist/xfwm4
src=src/theme.xcf

# Arrays
frames=('bottom' 'bottom-left' 'left' 'top-left' 'title-1' 'title-2')
title=('title-3')
buttons=('active' 'pressed')
signs=('close' 'hide' 'maximize' 'menu' 'shade' 'stick')

echo 'Welcome to Deck theme creator'
echo 'I require xcftools to process GIMP xcf file format and Imagemagick to process the rest of the steps.'

# remove old (should first check if they exist I guess)
rm -r $temp
rm -r $dist

# create
mkdir $temp
mkdir -p $dist


# Base frame
########################

for frame in ${frames[@]}
do
  # Extract xpm
  xcf2png -vC $src "$frame".xpm -o $temp/"$frame".xpm.temp

  # Convert PNG to XPM
  convert $temp/"$frame".xpm.temp +map $temp/"$frame"-active.xpm

  # Remove unused for now only (later we only remove the entire folder)
  #rm $temp/"$frame".xpm.temp
done

for val in ${frames[@]}
do
  # Skip bottom
  if [ "$val" = "bottom" ]
  then
    continue
  elif [ "$val" = "title-2" ]
  then
    convert $temp/"$val"-active.xpm -flop $temp/${val/2/4}-active.xpm
  elif [ "$val" = "title-1" ]
  then
    convert $temp/"$val"-active.xpm -flop $temp/${val/1/5}-active.xpm
  else
    convert $temp/"$val"-active.xpm -flop $temp/${val/left/right}-active.xpm
  fi
done

echo 'Base frame is done'



# Overlay frame
#########################

for frame in ${frames[@]}
do
  # Extract
  xcf2png -vCA $src "$frame".png -o $temp/"$frame".png.temp
done

for val in ${frames[@]}
do
  # Skip bottom
  if [ "$val" = "bottom" ]
  then
  convert $temp/"$val".png.temp -channel Alpha -evaluate Divide 2 png32:$temp/"$val"-active.png
  elif [ "$val" = "title-2" ]
  then
    convert $temp/"$val".png.temp -flop -channel Alpha -evaluate Divide 2 png32:$temp/${val/2/4}-active.png
  elif [ "$val" = "title-1" ]
  then
    convert $temp/"$val".png.temp -flop -channel Alpha -evaluate Divide 2 png32:$temp/${val/1/5}-active.png
  else
    convert $temp/"$val".png.temp -flop -channel Alpha -evaluate Divide 2 png32:$temp/${val/left/right}-active.png
  fi

  # Add opacity
  convert $temp/"$val".png.temp -channel Alpha -evaluate Divide 2 png32:$temp/"$val"-active.png
done


echo 'Overlay frame is done'


# Title plate
#################

xcf2png -vCA $src title-3.xpm -o $temp/title-3.xpm.temp
convert $temp/title-3.xpm.temp +map $temp/title-3-active.xpm


# Buttons // active, pressed
#################
for button in ${buttons[@]}
do
  # xpm
  xcf2png -vC $src "$button".xpm -o $temp/"$button".xpm.temp
  # png
  xcf2png -vCA $src "$button".png -o $temp/"$button".png.temp

  # Convert to xpm // Use this to merge with sign
  convert $temp/$button.xpm.temp +map $temp/$button.xpm

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


# Inactive state
################
mkdir -p $temp/cp

cp $temp/*.* $temp/cp/.
rename -v active inactive $temp/cp/*
mv $temp/cp/*.* $temp/.


# Post cleanup
#########
rm $temp/active.png $temp/active.xpm $temp/pressed.xpm $temp/pressed.png

# Prepare dist
##############
cp $temp/*.xpm $dist
cp $temp/*.png $dist


echo 'Should be a ready theme now'

