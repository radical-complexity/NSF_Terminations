# Preprocess the raw html files into text


i=0

# Only do this if it hasn't been done
for file in *.nsf.html;
do
  i=$((i+1))
  OUTFILEarr=(${file//./ })
  OUTFILE="$OUTFILEarr.nsf.txt"
  if [ ! -f $OUTFILE ] 
  then
     echo "Doing file $i: $file"
     textutil -convert txt $file    
  fi
done

# These are fast and harmless to re-do
sed -i.old $'s/\xE2\x80\xA8/ /g' *.nsf.txt
sed -i.old $'s/�/ /g' *.nsf.txt

rm -rf *.nsf.txt.old

