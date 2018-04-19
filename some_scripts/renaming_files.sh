for f in /home/cauretc/scratch/HiSeq_data/nxtrimmed/*.pe.*; do
	a="$(echo $f | sed s/.pe./.paired.pe./)"
	mv "$f" "$a"
	#echo $a
done
