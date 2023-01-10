for a in $(seq -f "%03g" 1 114); do
	printf "Downloading ${a}.mp3 ...\n"
	wget "http://www.all-quran.com/documents/Saad-Al-Ghamidi/Saad-Al-Ghamidi_files/${a}.mp3"
done
