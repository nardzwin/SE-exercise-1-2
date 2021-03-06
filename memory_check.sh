#!bin/bash
#SE exercise 1/2 
#Written by: Maynard Louis E. Prepotente
#Voyager IT Cadetship Training Program
#Script Name: memory_check.sh 

function sendReport() {
report=$( ps axo ruser,pid,%mem | sort -nr | head -n 11 )
reportDT=$(date +%Y%m%d" "%H:%M)

echo $report | mail -s "$reportDT memory check - critical" $1
}

MU=$( free | grep Mem: | awk '{ printf "%3.0f", ( $3 / $2 ) * 100 }')

while getopts "c:w:e:" opt; do

  case $opt in
  
  c ) CT=$OPTARG;;
  w ) WT=$OPTARG;;
  e ) EM=$OPTARG;;
  \?) echo "Invalid Argument";;
  
  esac
done

shift "$(($OPTIND -1))"

if [ ! -z "$CT" ] && [ ! -z "$WT" ] && [ ! -z "$EM" ]
  then
    if [[ "$CT" -gt "$WT" ]]
      then
        echo " Total Memory Usage: $MU"
        echo " Critical Threshold:  $CT"
        echo " Warning Threshold:   $WT"
        echo " Email:               $EM"
        
        if [ "$MU" -ge "$CT"]
          then
          sendReport $EM
          exit 2
        elif [ "$MU" -ge "$WT" ] && [ "$MU" -lt "$CT"]
          then
          exit 1
        else
          exit 0
        fi
      else
        echo "Critical Threshold should be greater than the Warning Threshold"
    fi
else
    echo "Please Supply these Parameters:"
    echo "-c: critical threshold, "
    echo "-w: Warning Threshold, "
    echo "-e: Email to send the report"
fi    
  
