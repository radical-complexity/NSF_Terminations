# Repackages data from the ./raw subdirectory
# into a new .csv file with additional information
#
# Assumes files have already been converted from
# html to text and special encoding/characters
# have been removed.



echo "AwardID,NSFDirectorate,NSFOrg,AwardInstrument,Recipient,Title,StartDate,EndDate,LastAmendmentDate,TotalIntendedAwardAmount,TotalAwardedAmountToDate,PrincipalInvestigator,PIEmail,Link,Abstract,HasProjectOutcomesReport,OB_2025,OB_2024,OB_2023,OB_2022,OB_2021,OB_2020,OB_2019,OB_2018,OB_2017,OB_2016,OB_2015,OB_2014,OB_2013">NSF_Canceled_Programs_Processed.csv

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
        Title=`grep -A 1 "^Award Abstract" ./raw/$awardID.nsf.txt | tail -n 1`
        StartDate=`grep -A 1 "Start Date" ./raw/$awardID.nsf.txt | tail -n 1 | sed -e 's/[[:space:]]*$//' | sed -e 's/^[[:space:]]*//'`
        EndDate=`grep -A 1 "End Date" ./raw/$awardID.nsf.txt | tail -n 1 | awk -F"(" '{print($1)};' | sed -e 's/[[:space:]]*$//' | sed -e 's/^[[:space:]]*//'`
        PrincipalInvestigator=`grep "(Principal Investigator)" ./raw/$awardID.nsf.txt | awk -F"(" '{print($1);}' | sed -e 's/[[:space:]]*$//' | sed -e 's/^[[:space:]]*//'`
        PrincipalInvestigatorEmail=`grep "(Principal Investigator)" ./raw/$awardID.nsf.txt | awk -F")" '{print($2);}' | sed -e 's/[[:space:]]*$//' | sed -e 's/^[[:space:]]*//'`
        AwardInstrument=`grep -A 1 "Award Instrument" ./raw/$awardID.nsf.txt | tail -n 1`
        Recipient=`grep -A 1 "Recipient:" ./raw/$awardID.nsf.txt | tail -n 1`
        TIAA=`grep -A 1 "Total Intended Award Amount:" ./raw/$awardID.nsf.txt | tail -n 1 `
        TAAD=`grep -A 1 "Total Awarded Amount to Date:" ./raw/$awardID.nsf.txt | tail -n 1 `
        OB2013=`grep -E "^FY 2013" ./raw/$awardID.nsf.txt | awk -F" " '{print($4);}'`
        OB2014=`grep -E "^FY 2014" ./raw/$awardID.nsf.txt | awk -F" " '{print($4);}'`
        OB2015=`grep -E "^FY 2015" ./raw/$awardID.nsf.txt | awk -F" " '{print($4);}'`
        OB2016=`grep -E "^FY 2016" ./raw/$awardID.nsf.txt | awk -F" " '{print($4);}'`
        OB2017=`grep -E "^FY 2017" ./raw/$awardID.nsf.txt | awk -F" " '{print($4);}'`
        OB2018=`grep -E "^FY 2018" ./raw/$awardID.nsf.txt | awk -F" " '{print($4);}'`
        OB2019=`grep -E "^FY 2019" ./raw/$awardID.nsf.txt | awk -F" " '{print($4);}'`
        OB2020=`grep -E "^FY 2020" ./raw/$awardID.nsf.txt | awk -F" " '{print($4);}'`
        OB2021=`grep -E "^FY 2021" ./raw/$awardID.nsf.txt | awk -F" " '{print($4);}'`
        OB2022=`grep -E "^FY 2022" ./raw/$awardID.nsf.txt | awk -F" " '{print($4);}'`
        OB2023=`grep -E "^FY 2023" ./raw/$awardID.nsf.txt | awk -F" " '{print($4);}'`
        OB2024=`grep -E "^FY 2024" ./raw/$awardID.nsf.txt | awk -F" " '{print($4);}'`
        OB2025=`grep -E "^FY 2025" ./raw/$awardID.nsf.txt | awk -F" " '{print($4);}'`
        LAD=`grep -A 1 "Latest Amendment Date:" ./raw/$awardID.nsf.txt | tail -n 1`
        ABSTRACT=`grep "^ABSTRACT" ./raw/$awardID.nsf.txt | sed -e 's/[\\"]//g' | sed -e 's/[\\*]*Abstract[\\*]*//g' | sed -e 's/^ABSTRACT[[:space:]]*.[[:space:]]*//' `
        ProjectOutcomes=`grep "^PROJECT OUTCOMES" ./raw/$awardID.nsf.txt | sed -e 's/[[:space:]].$//'`
        if [[ -z "$ProjectOutcomes" ]]; then
          ProjectOutcomes="NO"
        else
          ProjectOutcomes="YES"
        fi
        Link="https://www.nsf.gov/awardsearch/showAward?AWD_ID=$awardID"        

        echo "$awardID,$Directorate,\"$NSFOrg\",$AwardInstrument,\"$Recipient\",\"$Title\",\"$StartDate\",\"$EndDate\",\"$LAD\",\"$TIAA\",\"$TAAD\",$PrincipalInvestigator,$PrincipalInvestigatorEmail,$Link,\"$ABSTRACT\",\"$ProjectOutcomes\",\"$OB2025\",\"$OB2024\",\"$OB2023\",\"$OB2022\",\"$OB2021\",\"$OB2020\",\"$OB2019\",\"$OB2018\",\"$OB2017\",\"$OB2016\",\"$OB2015\",\"$OB2014\",\"$OB2013\"">>NSF_Canceled_Programs_Processed.csv
      else
        echo "Award $awardID does not exist."
      fi
    done
}<  $1.REPACKAGE.TMP

rm $1.REPACKAGE.TMP
echo "Done" 
