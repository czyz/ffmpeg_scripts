#!/bin/sh

# Zach Fine (zach@zachfine.com) - 6/3/2020

#construct something like this:
#ffmpeg -i /Volumes/drive/Avid\ MediaFiles/MXF/20200220_Ep206_Day_006_Drone_mxf_video/10pt6_V1_Plates_1SER26p370cd160-b8c0-f823023cb947V.mxf -filter:v "crop=in_w:in_h*9/10:0:in_h*.3/10" -r .2 DJI_002_%04d.png


if [ -x "/usr/local/bin/ffmpeg" ]; then
	echo "ffmpeg is installed and ready to go."
else
	echo "ffmpeg is not found at \"/usr/locall/bin/ffmpeg\". Please install it using homebrew."
	exit 1
fi

FRAMES_PER_SECOND=.33 #default to extracting 1 frame every 3 seconds
echo "Frames to extract per second (defaults to 1 frame every 3 seconds) [.33]"
read -p "> " newFRAMES_PER_SECOND
[ -n "$newFRAMES_PER_SECOND" ] && FRAMES_PER_SECOND=$newFRAMES_PER_SECOND
echo


echo "Enter the input directory path, followed by [ENTER]:"
read -p "> " INPUTDIR

if [ -d "$INPUTDIR" ]; then
	echo "input test passed - directory exists"
# directory exists
else
	echo
	echo "Directory \"$INPUTDIR\" does not exist. It can be tricky to manually enter filenames and correctly escape spaces and other special characters."
	echo "Dragging the output folder from the Finder into this window will automatically enter this information."
	echo "I'd recommend re-running the script, and try dragging the folder into this window when asked for the output directory path rather than trying to type it."
	exit 1 #we're out of here
fi

echo "* input dir is $INPUTDIR"
echo

EXTENSION=".mxf"
echo "Batch process all files in the directory matching what extension? [$EXTENSION]: "
read -p "> " newEXTENSION
[ -n "$newEXTENSION" ] && EXTENSION=$newEXTENSION
echo "* Matching *$EXTENSION."
echo

VIDEO_FILTER="crop=in_w:in_h*9/10:0:in_h*.3/10"
echo "Enter the video filter string -- the default was used on a production to crop the bottom of some DJI drone footage\n\
to remove burn-ins and is offered as an example. See the ffmpeg documentation to learn how to set up your own video filter [$VIDEO_FILTER]: "
read -p "> " newVIDEO_FILTER
[ -n "$newVIDEO_FILTER" ] && VIDEO_FILTER=$newVIDEO_FILTER
echo "* using  \"$VIDEO_FILTER\"."
echo



echo "Enter the output directory path, followed by [ENTER]:"
read -p "> " OUTPUTDIR

if [ -d "$OUTPUTDIR" ]; then
	echo "output directory test passed - directory exists"
# directory exists
	if [ ! -w "$OUTPUTDIR" ]; then
		echo
		echo "fail - Directory \"$OUTPUTDIR\" is not writable."
		exit 1 #we're out of here
	fi
else
	echo
	echo "Directory \"$OUTPUTDIR\" does not exist. It can be tricky to manually enter filenames and correctly escape spaces and other special characters."
	echo "Dragging the output folder from the Finder into this window will automatically enter this information."
	echo "I'd recommend re-running the script, and try dragging the folder into this window when asked for the output directory path rather than trying to type it."
	exit 1 #we're out of here
fi

echo "* output dir is $OUTPUTDIR"
echo

for foo in "$INPUTDIR/"*"$EXTENSION";
		do
			FILENAME=`basename "$foo"`
			BASEFILENAME=${FILENAME%$EXTENSION}
			echo "BASEFILENAME is $BASEFILENAME"
			runcmd="time ffmpeg -i \"${foo}\" -filter:v "${VIDEO_FILTER}" -r ${newFRAMES_PER_SECOND} \"$OUTPUTDIR/${BASEFILENAME}%04d.png\""

			echo "running:  ${runcmd}"

			eval $runcmd

#			echo "finished processing ${foo}"
			echo "-------------------"
			echo
			echo
			
		done;







