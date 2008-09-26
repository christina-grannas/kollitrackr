#!/bin/bash
# Track packages from posten.se


tracking_number=$1
app_name=$0


# Check that a tracking number is provided

if [ ! $tracking_number ]
	then
		echo "Ange kolli-id som argument!"
		echo "Exempel:" $app_name "[kolli-id]"
		exit
		echo "Om denna text syns, så är det fel nånstans."

	else
		echo "Spårar kolli" $tracking_number "via posten.se..."
fi


# Get html from posten.se by tracking_number and save it to a file
wget -qO $tracking_number.html "http://www.posten.se/tracktrace/TrackConsignments_do.jsp?trackntraceAction=saveSearch&logisticCustomerNumber=&referenceNumber=&lang=SE&loginHandlerImplClass=se.posten.pse.framework.security.applicationImpl.tracktrace.LoginHandlerImpl&internalPageNumber=0&doNotShowInHistory=true&consignmentId=$tracking_number&consignmentId=&consignmentId=&consignmentId=&consignmentId=&consignmentId=&consignmentId=&consignmentId="

# Save tracking history in $tracking_number.kolli:
# rm $tracking_number.kolli
echo "ID:  " $tracking_number > $tracking_number.kolli
echo -ne "Från: " >> $tracking_number.kolli
grep 'Fr&aring;n:' ./$tracking_number.html | sed 's/\///g' | sed 's/<[^>]*>//g' | sed 's/Fr&aring;n://g' | sed 's/^ *//g' | sed '/^$/d' >> $tracking_number.kolli 
echo -ne "Till: " >> $tracking_number.kolli
grep 'Till:' ./$tracking_number.html | sed 's/\///g' | sed 's/<[^>]*>//g' | sed 's/Till://g' | sed 's/&nbsp;//g' | sed 's/^ *//g' | sed '/^$/d' >> $tracking_number.kolli
echo -ne "Vikt: " >> $tracking_number.kolli
grep 'Vikt:' ./$tracking_number.html | sed 's/\///g' | sed 's/<[^>]*>//g' | sed 's/Vikt://g' | sed 's/^ *//g' | sed '/^$/d' >> $tracking_number.kolli
echo -ne "Typ:  " >> $tracking_number.kolli
grep 'Typ av f&ouml;rs&auml;ndelse:' ./$tracking_number.html | sed 's/\///g' | sed 's/<[^>]*>//g' | sed 's/Typ av f&ouml;rs&auml;ndelse://g' | sed 's/^ *//g' | sed '/^$/d' >> $tracking_number.kolli
echo  >> $tracking_number.kolli

echo "Tidpunkt          Händelse" >> $tracking_number.kolli

# Grep relevant information and save it to $tracking_number.kolli:
grep 'Historik' ./$tracking_number.html | sed 's/<tr>/\
/g' |  sed 's/<\/td>/   /g' | sed 's/<[^>]*>//g' | sed 's/Historik://g' | sed 's/DatumMeddelande//g' | sed 's/[,]//g' | sed '/^$/d' >> $tracking_number.kolli

# Display the file $tracking_number.kolli
echo
cat $tracking_number.kolli
echo

# Remove the temporaty html file
rm ./$tracking_number.html

