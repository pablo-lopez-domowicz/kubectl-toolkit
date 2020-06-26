#!/bin/bash  
echo "Searching for clientIds"


# test vals
# REDIS_NAME='tenant:658:audience:1111:2020.06.25.11.41'
# EKS_NAMESPACE='dev'
# JWT="eyJhbGciOiJSUzI1NiIsImtpZCI6ImltYy1hcGkifQ.eyJpc3MiOiJSVFAgQVBJIiwiaWF0IjoxNTkzMTkzNTgyLCJqdGkiOiJKZ2EtZGhENUp3MkVNYWFnNE50TWpBIiwib3JnYW5pemF0aW9uSWQiOiI2NTgiLCJ0aW1lem9uZSI6IkFtZXJpY2EvTmV3X1lvcmsiLCJ1c2VyTmFtZSI6IjY1OCIsInVzZXJJZCI6IjY1OCIsImN1bHR1cmFsTG9jYWxlIjoiZW5fVVMiLCJleHAiOjE1OTMyMjIzODJ9.o3b9Q3uhskK4IzU_rxgL3-B_w2KkpYWD_d0f_nqxsvB5krG_nhpoYDJImyDKWkJOi1iCLqcunDTeHyMzIvhUFjmUEK374ntBq8U4PoLvEs1XzD7s_1vUISUyMuUwMvrRuhA52j-SFqvZHjqjVGTnLkIeKfXEtNsKR2f6btzH2azIPDFLz5x_nyaDoXfBv798sXXuL6qAVNttcYmdfa-uA3SF3aUNOsFrPtOdXpOCLa43QN0fATA0y4LY0Rnvo6iP-n-jfpoWjwjo_0jrH7hkIV5hAwiHi_o8VCFWvJrrcA1qCU0bMslaaa09UXY-oSvZtXlV7Ya-ulNGys6qgt_Edg"
# INPUT_FILE='input.txt'

OUTPUT_FILE='output.txt'
echo "Start $date" > $OUTPUT_FILE
  
audience_pod=$(kubectl -n $EKS_NAMESPACE get po -o=name | grep -m 1 audience | sed 's/^.\\{4\\}//')
                            if [ -z "$audience_pod" ]
                            then
                                  echo "Cannot find any audience pod in namespace $EKS_NAMESPACE"
                                  exit 1
                            fi
i=1  
while read line; do  
    #Reading each line  
    echo "Line No. $i : $line"
    result=$(kubectl -n $EKS_NAMESPACE -c audience exec $audience_pod \
    -- curl -s "http://localhost:8080/private/audience/members?redisName=$REDIS_NAME&contactId=$line" \
    --header 'Content-Type:application/json' \
    --header "Authorization:Bearer $JWT")

    if [ -z "$result" ]; then result=FOUND; fi

    echo "$i - ClientId: $line - $result" >> $OUTPUT_FILE

    i=$((i+1))  

done < $INPUT_FILE  


