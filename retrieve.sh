#Retrieve information on NSF awards
#
# Given:
#
#   An input file in .csv format where the leftmost column is an NSF
#      award ID (has headers)
#   
# Creates:
#
#   A collection of output files named AWARD_ID.nsf.html (e.g. 1234567.nsf.html)
#      with the raw html retrieved, placed in a subdirectory named 'raw'
#
# Notes:
#
#   Will not re-retrieve any file for which a destination file
#      already exists
#   Pauses 1 second between retrievals
#
#
#
#
# Usage
#
# retrieve.sh FILENAME LINELIMIT


LL=$(($2+1))
head -n $LL $1>$1.TMP 
{
    read
    while IFS=, read -r awardID org title amt
    do
      if [ ! -f "./raw/$awardID.nsf.html" ] 
      then
        curl "https://www.nsf.gov/awardsearch/showAward?AWD_ID=$awardID" -o ./raw/$awardID.nsf.html 
        sleep 10
      else
        echo "Award $awardID already exists."
      fi
    done
}<  $1.TMP

rm $1.TMP
echo "Done"
