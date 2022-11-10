#!/bin/bash
printf ">>> METAR REPORT <<<\n"
printf "Report type:   "
egrep -o 'METAR|SPECI' metar.txt
printf "Airport code: "
egrep -o '\sK[A-Z]{3}\s' metar.txt
printf "\n"
#
day=$( egrep -o '\s[0-9]{6}Z\s' metar.txt | cut -c2-3 )
hour=$( egrep -o '\s[0-9]{6}Z\s' metar.txt | cut -c4-5 )
minute=$( egrep -o '\s[0-9]{6}Z\s' metar.txt | cut -c6-7 )
printf "This report was generated on day: %d at %d:%d Zulu hours" $day $hour $minute
printf "\n"
#
reportModifier=$( egrep -o 'AUTO|COR' metar.txt)
if [ "$reportModifier" = "AUTO" ]; then
	printf "\n>>> This is a fully automated report <<<"
elif [ "$reportModifier" = "COR" ]; then
	printf "\n>>> This is a corrected observation <<<"
else 
	printf "\n>>> No Modifier Present <<<"
fi
printf "\n" 
#
windDir=$( egrep -o '\s[0-9]{5}(G[0-9]{2})?KT\s' metar.txt | cut -c2-4 )
windSpd=$( egrep -o '\s[0-9]{5}(G[0-9]{2})?KT\s' metar.txt | cut -c5-6 )
printf "\nWinds are from %d degrees at %d Knots" $windDir $windSpd
#
gustFlag=$( egrep -o '\s[0-9]{5}(G[0-9]{2})?KT\s' metar.txt | cut -c7-7 )
if [ "$gustFlag" = "G" ]; then
   gustSpd=$( egrep -o '\s[0-9]{5}(G[0-9]{2})?KT\s' metar.txt | cut -c8-9 )
   printf "\nWinds are gusting at %d Knots" $gustSpd
fi
#
varWinds=$( egrep -o '\s[0-9]{3}V[0-9]{3}\s' metar.txt )
if [ -n "$varWinds" ]; then
   dir1=$( egrep -o '\s[0-9]{3}V[0-9]{3}\s' metar.txt | cut -c2-4)
   dir2=$( egrep -o '\s[0-9]{3}V[0-9]{3}\s' metar.txt | cut -c6-8)
   printf "\nWinds are variable from %s degrees to %s degrees" $dir1 $dir2
fi
printf "\n"
#
skyClouds=$( egrep -o "\sSKC\s" metar.txt)
if [ -n "$skyClouds" ]; then
	printf "\nThe Sky is Clear below 12,000 feet"
fi 

clrClouds=$( egrep -o "\sCLR\s" metar.txt)
if [ -n "$clrClouds" ]; then
	printf "\nThe Sky is clear below 12,000 feet"
fi 

fewClouds=$( egrep -o '\sFEW[0-9]{3}\s' metar.txt | cut -c5-7 ) 
if [ -n "$fewClouds" ]; then
	fewClouds=$(( 10#$fewClouds * 100 ))
	printf "\nFew Clouds at %s feet" "$fewClouds"
fi 

sctClouds=$( egrep -o '\sSCT[0-9]{3}\s' metar.txt | cut -c5-7) 
if [ -n "$sctClouds" ]; then
	sctClouds=$(( 10#$sctClouds * 100 ))
	printf "\nScattered Clouds at %s feet" "$sctClouds"
fi

bknClouds=$( egrep -o '\sBKN[0-9]{3}\s' metar.txt | cut -c5-7)
if [ -n "$bknClouds" ]; then
	bknClouds=$(( 10#$bknClouds * 100 ))
	printf "\nBroken Clouds at %s feet" "$bknClouds"
fi

ovcClouds=$( egrep -o '\sOVC[0-9]{3}\s' metar.txt | cut -c5-7) 
if [ -n "$ovcClouds" ]; then
	ovcClouds=$(( 10#$ovcClouds * 100 ))
	printf "\nOvercast Clouds at %s feet" "$ovcClouds"
fi
printf "\n"
#
tempDew=$( egrep -o '[0-9][0-9]/[0-9][0-9]' metar.txt)
if [ -n "$tempDew" ]; then 
	tempPart=$( egrep -o '[0-9][0-9]/[0-9][0-9]' metar.txt | cut -c1-2 ) 
	dewPart=$( egrep -o '[0-9][0-9]/[0-9][0-9]' metar.txt | cut -c4-5 )
	printf "\nThe temperature is $tempPart degrees C."
	printf "\nThe dew-point is $dewPart degrees C."
fi 
mmtempDew=$( egrep -o '\sM[0-9][0-9]/M[0-9][0-9]\s' metar.txt)
if [ -n "$mmtempDew" ]; then 
	mmTemp=$( egrep -o 'M[0-9][0-9]/M[0-9][0-9]' metar.txt | cut -c2-3 )
	mmDew=$( egrep -o 'M[0-9][0-9]/M[0-9][0-9]' metar.txt | cut -c6-7 )
	printf "\nThe Temperature is MINUS $mmTemp degrees C."
	printf "\nThe Dew-point is MINUS $mmDew degrees C."
fi 
mtempDew=$( egrep -o '\sM[0-9][0-9]/[0-9][0-9]\s' metar.txt)
if [ -n "$mtempDew" ]; then 
	mTemp=$( egrep -o '\sM[0-9][0-9]/[0-9][0-9]\s' metar.txt | cut -c3-4)
	mDew=$( egrep -o '\sM[0-9][0-9]/[0-9][0-9]\s' metar.txt | cut -c6-7)
	printf "\nThe Temperature is MINUS $mTemp degrees C."
	printf "\nThe Dew-point is $mDew degrees C."
fi 
tempmDew=$( egrep -o '\s[0-9][0-9]/M[0-9][0-9]\s' metar.txt)
if [ -n "$tempmDew" ]; then
	temp=$( egrep -o '[0-9][0-9]/M[0-9][0-9]' metar.txt | cut -c1-2) 
	dew=$( egrep -o '[0-9][0-9]/M[0-9][0-9]' metar.txt | cut -c5-6) 
	printf "\nThe Temperature is $temp degrees C."
	printf "\nThe Dew-point is MINUS $dew degrees C." 
fi 
#
barPressure=$( egrep -o '\sA[0-9]{4}\s' metar.txt )
if [ -n "$barPressure" ]; then
	pressOne=$( egrep -o '\sA[0-9]{4}\s' metar.txt | cut -c3-4 )
	pressTwo=$( egrep -o '\sA[0-9]{4}\s' metar.txt | cut -c5-7 )
	printf "\nThe altimeter reads $pressOne.$pressTwo inches of mecury" 
fi
printf "\n"

#
twoSM=$( egrep -o '\s[0-9][0-9]SM\s' metar.txt)
if [ -n "$twoSM" ]; then
	twoCalc=$( egrep -o '\s[0-9][0-9]SM\s' metar.txt | cut -c1-3) 
	printf "\nVisiblity is: $twoCalc statute miles"
fi 

quartSM=$( egrep -o '\sM[0-9]/[0-9]SM\s' metar.txt)
if [ -n "$quartSM" ]; then 
	smCalc=$( egrep -o '\sM[0-9]/[0-9]SM\s' metar.txt | cut -c1-5 ) 
	printf "\nVisibility is: $smCalc statue miles" 
fi 
lightRain=$( egrep -o '\s\-RA\s' metar.txt) 
if [ -n "$lightRain" ]; then 
	printf "\nLight Rain has been Reported in the Area"
fi 
mediumRain=$( egrep -o '\sRA\s' metar.txt)
if [ -n "$mediumRain" ]; then 
	printf "\nMedium Rain has been Reported in the Area"
fi 
heavyRain=$( egrep -o '\s\+RA\s' metar.txt)
if [ -n "$heavyRain" ]; then 
	printf "\n<<<CAUTION>>> Heavy Rain has been Reported in the Area"
fi 

tStorms=$( grep -i "\sTH\s" metar.txt)
if [ -n "$tStorms" ]; then
printf "\n<<<CAUTION>>> Thunderstorms reported in the area"
fi 




