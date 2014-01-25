#!/bin/bash

# @author Henrik Lundgren
# @date 2014-01-23
# @url github.com/henriklundgren/deck

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

clear

intro='
--------------------------------------------
Welcome to Deck theme creator.
============================================
\E[32m          __________________________
 ________|   ____           _       |_______
 \       |  (|   \Xfwm     | |      |      /
  \      |   |    | _   __ | |      |     /
   \     |  _|    ||/  /   |/_)     |    /
   /     | (/\___/ |__/\__/| \_/\E[31mv0.1\E[32m|    \
  /      |__________________________|     \
 /__________)                    (_________\

\E[0m
============================================
Script to build and deploy Deck Xfwm theme
on any Xfce GNU/Linux OS.

More information about Deck and this script
can be found on the Github page.
http://github.com/henriklundgren/deck

I will extract layers from xcf
source file and prepare sprite
for distribution.
-------------------------------------------
'
echo -e "$intro"

# Make sure requirements are meet.
command -v xcfinfo >/dev/null 2>&1 || { echo "Require Xcftools but it's not installed. Aborting." >&2; exit 1; }
command -v convert >/dev/null 2>&1 || { echo "Require Imagemagick but it's not installed. Aborting." >&2; exit 1; }

read -p "Press [ENTER] to continue..."

# Put output in variable and make test to see if source has all layers
#xcfinfo -v $src

# remove old (should first check if they exist I guess)
rm -r $temp
rm -r $dist

# create
mkdir $temp
mkdir -p $dist

echo -e "
======================================
The default frame has a lightgrey base
color. You can change this now if you
like to.
--------------------------------------
"
echo -en "What color do you want [lightgrey]: "; read ask_color

# Base frame
########################

for frame in ${framesActive[@]}; do
  # Extract xpm
  xcf2png -C   $src  "$frame".xpm    -o $temp/"$frame".xpm.temp
  # Convert PNG to XPM
  convert $temp/"$frame".xpm.temp   +map    $temp/"$frame".xpm

  # Change base color
  if [ "$ask_color" ]; then
    convert  $temp/"$frame".xpm -alpha extract -background "$ask_color" -alpha shape $temp/"$frame".xpm
  fi
done

for frame in ${framesInactive[@]}; do
  # Extract xpm
  xcf2png -C $src "$frame".xpm -o $temp/"$frame".xpm.temp

  # Convert PNG to XPM
  convert $temp/"$frame".xpm.temp +map $temp/"$frame".xpm

  # Change base color
  if [ "$ask_color" ]; then
    convert  $temp/"$frame".xpm -alpha extract -background "$ask_color" -alpha shape $temp/"$frame".xpm
  fi
done

for val in ${framesActive[@]}; do
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

for val in ${framesInactive[@]}
do
  # Skip bottom
  if [ "$val" = "bottom-inactive" ]
  then
    continue
  elif [ "$val" = "title-2-inactive" ]
  then
    convert $temp/"$val".xpm -flop $temp/${val/2/4}.xpm
  elif [ "$val" = "title-1-inactive" ]
  then
    convert $temp/"$val".xpm -flop $temp/${val/1/5}.xpm
  else
    convert $temp/"$val".xpm -flop $temp/${val/left/right}.xpm
  fi
done



xpm_file_array=($(ls --ignore=*.temp $temp)) # http://stackoverflow.com/a/13824135
xpm_base_array=([1]=bottom [2]=bottom-left [3]=left [4]=top-left [5]=top-right
[6]=right [7]=bottom-right [8]=title-1 [9]=title-2 [10]=title-4 [11]=title-5);

#echo -en "The number of files found: ${#xpm_file_array[*]}"

# Function to check output files with expected result
check_if_xpm_exist() {
  local switch=false
  for item in ${xpm_file_array[@]}; do
    if [ "$item" = "$1"-"$2".xpm ]; then
      switch=true
      echo -en "[\E[0;32mOK\E[0m]"
    fi
  done

  if [ "$switch" == false ]; then
    echo -en "[\E[0;31m--\E[0m]"
  fi
}

printf '\n%-30s\n' "-------------------------------------"
printf '\e[37;40m%-30s\e[0m\n' "|:              Output             :|"
printf '%-30s\n' "-------------------------------------"
printf '%-14s %-8s %-8s\n' "| " "| Active " "| Inactive |"
printf '%-30s\n' "-------------------------------------"
printf '%-14s %-8s %-8s\n' "| ${xpm_base_array[1]}" "|  $(check_if_xpm_exist ${xpm_base_array[1]} active)  " "|   $(check_if_xpm_exist ${xpm_base_array[1]} inactive)   |"
printf '%-30s\n' "-------------------------------------"
printf '%-14s %-8s %-8s\n' "| ${xpm_base_array[2]}" "|  $(check_if_xpm_exist ${xpm_base_array[2]} active)  " "|   $(check_if_xpm_exist ${xpm_base_array[2]} inactive)   |"
printf '%-30s\n' "-------------------------------------"
printf '%-14s %-8s %-8s\n' "| ${xpm_base_array[3]}" "|  $(check_if_xpm_exist ${xpm_base_array[3]} active)  " "|   $(check_if_xpm_exist ${xpm_base_array[3]} inactive)   |"
printf '%-30s\n' "-------------------------------------"
printf '%-14s %-8s %-8s\n' "| ${xpm_base_array[4]}" "|  $(check_if_xpm_exist ${xpm_base_array[4]} active)  " "|   $(check_if_xpm_exist ${xpm_base_array[4]} inactive)   |"
printf '%-30s\n' "-------------------------------------"
printf '%-14s %-8s %-8s\n' "| ${xpm_base_array[5]}" "|  $(check_if_xpm_exist ${xpm_base_array[5]} active)  " "|   $(check_if_xpm_exist ${xpm_base_array[5]} inactive)   |"
printf '%-30s\n' "-------------------------------------"
printf '%-14s %-8s %-8s\n' "| ${xpm_base_array[6]}" "|  $(check_if_xpm_exist ${xpm_base_array[6]} active)  " "|   $(check_if_xpm_exist ${xpm_base_array[6]} inactive)   |"
printf '%-30s\n' "-------------------------------------"
printf '%-14s %-8s %-8s\n' "| ${xpm_base_array[7]}" "|  $(check_if_xpm_exist ${xpm_base_array[7]} active)  " "|   $(check_if_xpm_exist ${xpm_base_array[7]} inactive)   |"
printf '%-30s\n' "-------------------------------------"
printf '%-14s %-8s %-8s\n' "| ${xpm_base_array[8]}" "|  $(check_if_xpm_exist ${xpm_base_array[8]} active)  " "|   $(check_if_xpm_exist ${xpm_base_array[8]} inactive)   |"
printf '%-30s\n' "-------------------------------------"
printf '%-14s %-8s %-8s\n' "| ${xpm_base_array[9]}" "|  $(check_if_xpm_exist ${xpm_base_array[9]} active)  " "|   $(check_if_xpm_exist ${xpm_base_array[9]} inactive)   |"
printf '%-30s\n' "-------------------------------------"
printf '%-14s %-8s %-8s\n' "| ${xpm_base_array[10]}" "|  $(check_if_xpm_exist ${xpm_base_array[10]} active)  " "|   $(check_if_xpm_exist ${xpm_base_array[10]} inactive)   |"
printf '%-30s\n' "-------------------------------------"
printf '%-14s %-8s %-8s\n' "| ${xpm_base_array[11]}" "|  $(check_if_xpm_exist ${xpm_base_array[11]} active)  " "|   $(check_if_xpm_exist ${xpm_base_array[11]} inactive)   |"
printf '%-30s\n' "-------------------------------------"




#base_files=`ls --ignore=*.temp $temp`
#echo -n "$base_files"

if [ "${#xpm_file_array[@]}" = 22 ]
then
  echo -e "
*************************************
\e[31m#####################################
#### ### ###     #####  #####  ######
##### # ####      ####   ###   ######
###### #####     ##### #  #  # ######
##### # #### ######### ##   ## ######
###  ### ### ######### ####### ######
#####################################\e[0m
=====================================
Correct amount of sprites found.
  "
  echo -en ${#xpm_file_array[@]}
else
  echo "
===================================
Something went wrong. Aborting.
  "
  exit 1
fi

read -p "
Press [RETURN] to continue..."
clear



# Overlay frame
#########################

for frame in ${framesActive[@]}
do
  # Extract
  xcf2png -CA $src "$frame".png -o $temp/"$frame".png.temp
done

for frame in ${framesInactive[@]}
do
  # Extract
  xcf2png -CA $src "$frame".png -o $temp/"$frame".png.temp
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

ls --ignore='*.temp' --ignore='*.xpm' $temp
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

