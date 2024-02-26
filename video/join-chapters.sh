#!/usr/bin/env bash

joinfile=$1
VIDEOTITLE=$2
VIDEOARTIST=$3
MDFILEHEADER=";FFMETADATA1\ntitle=\"$VIDEOTITLE\"\nartist=\"$VIDEOARTIST\"\n"

write_metadata () {
  duration=$(ffprobe -v quiet -of csv=p=0 -show_entries format=duration $videofile)
  chapter_descriptor="[CHAPTER]\nTIMEBASE=1/1\nSTART=$start\n"
  end=$(awk -v OFMT='%f' "BEGIN{ print $start + $duration }")
  chapter_descriptor+="END=$end\n"
  chapter_descriptor+="title=$chapter\n"
  start=$end
  echo -e $chapter_descriptor >> metadata.txt
}

echo -e $MDFILEHEADER > metadata.txt

start=0

while IFS=':' read -r videofile chapter
do
  printf "$videofile \n"
  printf "CHAPTER: $chapter \n"
  echo "file '$videofile'" >> joinlist.txt
  write_metadata
done < "$joinfile"

ffmpeg -f concat -safe 0 -i joinlist.txt -i metadata.txt -map_metadata 1 -c copy output.mp4

