#!/bin/bash
# Söka kolli på posten.se


kolliid=$1
programnamn=$0


#Kontrollera att kolli-id är angett:

if [ ! $kolliid ]
	then
		echo "Ange kolli-id som argument!"
		echo "Exempel:" $programnamn "[kolli-id]"
		exit
		echo "Om denna text syns, så är det fel nånstans."

	else
		echo "Spårar kolli" $1 "via posten.se..."
fi


# Hämta (temporär) html-fil från posten.se, $kolliid angett i url:
wget -qO $1.html "http://www.posten.se/tracktrace/TrackConsignments_do.jsp?trackntraceAction=saveSearch&logisticCustomerNumber=&referenceNumber=&lang=SE&loginHandlerImplClass=se.posten.pse.framework.security.applicationImpl.tracktrace.LoginHandlerImpl&internalPageNumber=0&doNotShowInHistory=true&consignmentId=$kolliid&consignmentId=&consignmentId=&consignmentId=&consignmentId=&consignmentId=&consignmentId=&consignmentId="

# Spara info om kollit i $1.kolli:
# rm $1.kolli
echo "ID:  " $1 > $1.kolli
echo -ne "Från: " >> $1.kolli
grep 'Fr&aring;n:' ./$1.html | sed 's/\///g' | sed 's/<[^>]*>//g' | sed 's/Fr&aring;n://g' | sed 's/^ *//g' | sed '/^$/d' >> $1.kolli 
echo -ne "Till: " >> $1.kolli
grep 'Till:' ./$1.html | sed 's/\///g' | sed 's/<[^>]*>//g' | sed 's/Till://g' | sed 's/&nbsp;//g' | sed 's/^ *//g' | sed '/^$/d' >> $1.kolli
echo -ne "Vikt: " >> $1.kolli
grep 'Vikt:' ./$1.html | sed 's/\///g' | sed 's/<[^>]*>//g' | sed 's/Vikt://g' | sed 's/^ *//g' | sed '/^$/d' >> $1.kolli
echo -ne "Typ:  " >> $1.kolli
grep 'Typ av f&ouml;rs&auml;ndelse:' ./$1.html | sed 's/\///g' | sed 's/<[^>]*>//g' | sed 's/Typ av f&ouml;rs&auml;ndelse://g' | sed 's/^ *//g' | sed '/^$/d' >> $1.kolli
echo  >> $1.kolli

echo "Tidpunkt          Händelse" >> $1.kolli

# Sortera ut relevant textoch spara i $1.kolli:
grep 'Historik' ./$1.html | sed 's/<tr>/\
/g' |  sed 's/<\/td>/   /g' | sed 's/<[^>]*>//g' | sed 's/Historik://g' | sed 's/DatumMeddelande//g' | sed 's/[,]//g' | sed '/^$/d' >> $1.kolli

# Visa filen $1.kolli
echo
cat $1.kolli
echo

# Tag bort den temporära html-filen som hämtats från posten.se:
rm ./$1.html

