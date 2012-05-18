#!/bin/bash


if [ "" == "$1" ] || [ "" == "$2" ]; then
  echo "ERROR USAGE:Parameters missing"
  echo "You must suplly command line arguments!"
  echo "Enter remote or local"
  echo "Enter firefox,safari or iexplore for the environment to test on";
  exit
else
  ui1=$1
  ui2=$2
  ui3=$3
fi

if [ "$ui3" == "login" ]; then
  ruby login.rb $ui1 $ui2;
else
  ruby regression.rb $ui1 $ui2;
fi	
exit 0;
