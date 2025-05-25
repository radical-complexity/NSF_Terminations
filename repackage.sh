# Repackages data from the ./raw subdirectory
# into a new .csv file with additional information
#
# Assumes files have already been converted from
# html to text and special encoding/characters
# have been removed.



echo "AwardID,NSFDirectorate,NSFOrg,AwardInstrument,Recipient,StartDate,EndDate,LastAmendmentDate,TotalIntendedAwardAmount,TotalAwardedAmountToDate,PrincipalInvestigator,PIEmail,HasProjectOutcomesReport,Link,Abstract">NSF_Canceled_Programs_Processed.csv

LL=$(($2+1))

head -n $LL $1>$1.REPACKAGE.TMP
{
    read
    while IFS=, read -r awardID dir org title amt REST
    do
      Directorate=`echo $dir | tr -d '[:space:]'`
      if [ -f "./raw/$awardID.nsf.txt" ]
      then
        NSFOrg=`grep -A 2 "NSF Org:" ./raw/$awardID.nsf.txt | tail -n 1 | sed -e 's/[[:space:]]*$//'`
        StartDate=`grep -A 1 "Start Date" ./raw/$awardID.nsf.txt | tail -n 1 | sed -e 's/[[:space:]]*$//' | sed -e 's/^[[:space:]]*//'`
        EndDate=`grep -A 1 "End Date" ./raw/$awardID.nsf.txt | tail -n 1 | awk -F"(" '{print($1)};' | sed -e 's/[[:space:]]*$//' | sed -e 's/^[[:space:]]*//'`
        PrincipalInvestigator=`grep "(Principal Investigator)" ./raw/$awardID.nsf.txt | awk -F"(" '{print($1);}' | sed -e 's/[[:space:]]*$//' | sed -e 's/^[[:space:]]*//'`
        PrincipalInvestigatorEmail=`grep "(Principal Investigator)" ./raw/$awardID.nsf.txt | awk -F")" '{print($2);}' | sed -e 's/[[:space:]]*$//' | sed -e 's/^[[:space:]]*//'`
        AwardInstrument=`grep -A 1 "Award Instrument" ./raw/$awardID.nsf.txt | tail -n 1`
        Recipient=`grep -A 1 "Recipient:" ./raw/$awardID.nsf.txt | tail -n 1`
        TIAA=`grep -A 1 "Total Intended Award Amount:" ./raw/$awardID.nsf.txt | tail -n 1 `
        TAAD=`grep -A 1 "Total Awarded Amount to Date:" ./raw/$awardID.nsf.txt | tail -n 1 `
        LAD=`grep -A 1 "Latest Amendment Date:" ./raw/$awardID.nsf.txt | tail -n 1`
        #ABSTRACT=`grep "^ABSTRACT" ./raw/$awardID.nsf.txt | sed -e 's/[\\"]//g' | sed -e 's/[\\*]*Abstract[\\*]*//g' | sed -e 's/^ABSTRACT[[:space:]]*.*[[:space:]]*//`
        ABSTRACT=`grep "^ABSTRACT" ./raw/$awardID.nsf.txt | sed -e 's/[\\"]//g' | sed -e 's/[\\*]*Abstract[\\*]*//g' | sed -e 's/^ABSTRACT[[:space:]]*.[[:space:]]*//' `
        ProjectOutcomes=`grep "^PROJECT OUTCOMES" ./raw/$awardID.nsf.txt | sed -e 's/[[:space:]].$//'`
        
        echo "$awardID,$Directorate,\"$NSFOrg\",$AwardInstrument,\"$Recipient\",\"$StartDate\",\"$EndDate\",\"$LAD\",\"$TIAA\",\"$TAAD\",$PrincipalInvestigator,$PrincipalInvestigatorEmail,\"$ProjectOutcomes\",https://www.nsf.gov/awardsearch/showAward?AWD_ID=$awardID,\"$ABSTRACT\"">>NSF_Canceled_Programs_Processed.csv
      else
        echo "Award $awardID does not exist."
      fi
    done
}<  $1.REPACKAGE.TMP

rm $1.REPACKAGE.TMP
echo "Done" 
