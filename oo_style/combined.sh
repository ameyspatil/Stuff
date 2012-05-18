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
fi

if [ "$ui1" == "dev" ]; then
	echo "You have selected your local host to test on. That being http://js01.internal.jibe.com:3000/"; 
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


if [ "$ui1" == "dev" ]; then
	prove --timer --formatter TAP::Formatter::JUnit combined.pl :: $ui1 $ui2  > ../../logs/oo_logs/output_dev_oo_style.xml; 
elif [ "$ui1" == "stg" ]; then
	prove --timer --formatter TAP::Formatter::JUnit combined.pl :: $ui1 $ui2  > ../../logs/oo_logs/output_stg_oo_style.xml;
elif [ "$ui1" == "prd" ]; then
	prove --timer --formatter TAP::Formatter::JUnit combined.pl :: $ui1 $ui2  > ../../logs/oo_logs/output_prd_oo_style.xml;
else
 	echo "Invalid code base choice";
	exit;
fi


exit 0;
