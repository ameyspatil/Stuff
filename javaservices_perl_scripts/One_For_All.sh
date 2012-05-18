#!/bin/bash
#!/bin/perl

if [ "" == "$1" ] || [ "" == "$2" ]; then
  echo "ERROR USAGE:Parameters missing"
  echo "You must suplly command line arguments!"
  echo "Enter prd,dev or stg for the code base to test on"
  echo "Enter firefox,safari or iexplore for the environment to test on";
  exit
else
  ui1=$1
  ui2=$2
  ui3=$3
fi

if [ "$ui1" == "dev" ]; then
	echo "You have selected your local host to test on. That being http://localhost:3000/"; 
elif [ "$ui1" == "stg" ]; then
	echo "You have selected the staging environment to test on. That being http://jibe.testbacon.com/ ";
elif [ "$ui1" == "prd" ]; then
	echo "You have selected the production environment to test on. That being http://www.jibe.com/";
else
 	echo "Invalid code base choice";
	exit;
fi

if [ "$ui2" == "firefox" ]; then
	echo "You have selected the Firefox4 browser to test the website."; 
elif [ "$ui2" == "safari" ]; then
	echo "You have selected the Safari2 browser to test the website.";
elif [ "$ui2" == "iexplore" ]; then
	echo "You have selected the Internet Explorer 8 browser to test the website.";
elif [ "$ui2" == "chrome" ]; then
	echo "You have selected the Chrome browser to test the website.";        
else
 	echo "Invalid browser choice";
	exit;
fi

if [ "$ui3" == "old" ]; then
	prove --timer --formatter TAP::Formatter::JUnit scripts/javaservices_perl_scripts/one_for_all.pl :: $ui1 $ui2  > logs/javaservices_logs/output_one_for_all.x1ml;
elif [ "$ui3" == "new" ]; then
	prove --timer --formatter TAP::Formatter::JUnit scripts/javaservices_perl_scripts/new_job_app_flow.pl :: $ui1 $ui2  > logs/javaservices_logs/output_one_for_all.x2ml;
fi



exit 0;
