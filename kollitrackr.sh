#!/bin/bash

if [ $1 ]; then

number=$1

else

echo -n "Ange ditt kollinummer:"
read number
fi

wget -O response.html "http://www.posten.se/tracktrace/TrackConsignments_do.jsp?trackntraceAction=saveSearch&logisticCustomerNumber=&referenceNumber=&lang=SE&loginHandlerImplClass=se.posten.pse.framework.security.applicationImpl.tracktrace.LoginHandlerImpl&internalPageNumber=0&doNotShowInHistory=true&consignmentId=$number&consignmentId=&consignmentId=&consignmentId=&consignmentId=&consignmentId=&consignmentId=&consignmentId="


grep '<h3>' ./response.html

rm ./response.html
