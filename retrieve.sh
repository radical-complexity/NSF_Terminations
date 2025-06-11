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
#   Pauses 10 seconds between retrievals (to not overwhelm server)
#
# Usage
#
# retrieve.sh FILENAME LINELIMIT
#
# Usage example
# ./retrieve.sh NSF-Terminated-Awards.csv 100
#

# Determine the line limit
# Note that the line limit number is 1 greater than the arg passed
# to account for the header row
LL=$(($2+1))

# Make a copy with only the required lines
head -n $LL $1>$1.TMP 

# Begin to read the temp file
{
    # This reads (and ignores) the header line
    read
    while IFS=, read -r awardID org title amt
    do
      # If the destination file does not exist:
      if [ ! -f "./raw/$awardID.nsf.html" ] 
      then
        # Execute the web request to get the page from NSF's servers
        curl "https://www.nsf.gov/awardsearch/showAward?AWD_ID=$awardID" -o ./raw/$awardID.nsf.html
        # Wait N seconds. Change this number to go faster (more requests/minute) 
        sleep 10
      else
        # Comment this out if you don't want to see every record that is skipped
        echo "Award $awardID already exists."
      fi
    done
}<  $1.TMP

rm $1.TMP
echo "Done"
