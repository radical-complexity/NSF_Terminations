# Preprocess raw html files into text
#
# Note that this relies on the textutil program
# on Mac OS. In theory another program
# could be used (e.g. Pandoc) but this was
# native.
#
# Will process any file that exists named *.nsf.html
#
# Note that it will skip files that already have 
# a 
#
# Usage:
#
# ./preprocess.sh
#


# Establish a counter to keep track of progress
i=0

for file in *.nsf.html;
do
  i=$((i+1))
  OUTFILEarr=(${file//./ })
  OUTFILE="$OUTFILEarr.nsf.txt"
  # Only do this if it hasn't been done
  if [ ! -f $OUTFILE ] 
  then
     echo "Doing file $i: $file"
     textutil -convert txt $file    
  fi
done


# These are fast and harmless to re-do
# So they get re-called on every output file (!)
# They replace some funky characters that show up

sed -i.old $'s/\xE2\x80\xA8/ /g' *.nsf.txt
sed -i.old $'s/�/ /g' *.nsf.txt
rm -rf *.nsf.txt.old

