#!/bin/bash  
echo "Searching for clientIds"

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


