#!/bin/bash
#Graham Brown 200333656 March 5th 2018
#This script implements tasks for the bash semester assignment
#This is my first script please be gentle :)

#Define functions for error messages and display command line help
#Displays the Help Tab if the USER inputs an incorrect command or types -h | -help
function displayhelp {
  cat << EOF
  Usage: $0 [-h | --help] [output option, ...]
  Output options can be one or more of the following:
    -n | --nameinfo
    -i | --ipinfo
    -o | --osinfo
    -c | --cpuinfo
    -m | --meminfo
    -d | --diskinfo
    -p | --printinfo
    -s | --softinfo
EOF
}

#Function for Calling the Error Message subscript up
function errormessage {
  echo "$@" >&2
}

#Process the command line options, saving the variable for later use
#runindefault=yes allows the Script to Run All functions at once if the user does not specify a specific parameter for an output option

#THIS IS THE MAIN WHILE LOOP
runindefault="yes"
while [ $# -gt 0 ]; do
  case "$1" in
    -h|--help)
      displayhelp
      exit 0
      ;;
    -n|--namesinfo)
      nameinfowanted="yes"
      runindefault="no"
      ;;
    -i|--ipaddress)
      ipinfowanted="yes"
      runindefault="no"
      ;;
    -o|--osinfo)
      osinfowanted="yes"
      runindefault="no"
      ;;
    -c|--cpuinfo)
      cpuinfowanted="yes"
      runindefault="no"
      ;;
    -m|--memory)
      meminfowanted="yes"
      runindefault="no"
      ;;
    -d|--diskinfo)
      diskinfowanted="yes"
      runindefault="no"
      ;;
    -p|--printinfo)
      printinfowanted="yes"
      runindefault="no"
      ;;
    -s|--softinfo)
      softinfowanted="yes"
      runindefault="no"
      ;;
    *)
      errormessage "Sorry I don't recognize the command '$1'"
      errormessage "$(displayhelp)"
      exit 1
      ;;
  esac
  shift
done

#This is the IF Statements that Check the Option the User wanted to Print. When the Command is Selected:
#(eg. -n), then the Script will Check if the $nameinfowanted variable is a YES, triggering the secondary IF check later on in the script/
#This is also the place where the commands to check hostname, memory free, etc. are run. When the commands are TRUE then the output variable
#gets the command writen to it

if [ "$runindefault" = "yes" -o "$nameinfowanted" = "yes" ]; then
  nameinfo="$(hostname && domainname)"
fi

if [ "$runindefault" = "yes" -o "$ipinfowanted" = "yes" ]; then
  ipinfo="$(ip -o address | grep "ens33" | sed -n '1p' | awk '{print $4;}')"
fi

if [ "$runindefault" = "yes" -o "$osinfowanted" = "yes" ]; then
  osinfo="$(grep PRETTY /etc/os-release | sed -e 's/.*=//' -e 's/\"//g')"
fi

if [ "$runindefault" = "yes" -o "$cpuinfowanted" = "yes" ]; then
  cpuinfo="$(lscpu | grep 'Model name' | sed -e 's/.*://' -e 's/^[ \t]*//')"
fi

if [ "$runindefault" = "yes" -o "$meminfowanted" = "yes" ]; then
  meminfo="$(free -m | head -2)"
fi

if [ "$runindefault" = "yes" -o "$diskinfowanted" = "yes" ]; then
  diskinfo="$(df -h / | awk '{print $2,$3,$4;}')"
fi

if [ "$runindefault" = "yes" -o "$printinfowanted" = "yes" ]; then
  printinfo="$(lpstat -p)"
fi

if [ "$runindefault" = "yes" -o "$softinfowanted" = "yes" ]; then
  softinfo="$(dpkg --get-selections)"
fi

#This is where we create the output using the gathered command line options and data and is fed back to the USER as an output in the Terminal
#Here the Spaces between the info output and the variables are actually followed through to the Terminal, making it clearer for the user to read

nameinfooutput="System Name and Domain name (If Applicable):
$nameinfo
-----------------------------"

ipinfooutput="IP Address:
$ipinfo
-----------------------------"
osinfooutput="Operating System:
$osinfo
-----------------------------"
cpuinfooutput="CPU Information:
$cpuinfo
-----------------------------"

meminfooutput="Memory Information:
$meminfo
-----------------------------"
diskinfooutput="Disk Information:
$diskinfo
-----------------------------"
printinfooutput="Printer Information:
$printinfo
-----------------------------"

softinfooutput="Software Installed:
$softinfo
-----------------------------"

#This is the part of the script where it checks if the infowanted is TRUE and will Display the output to the terminal. If the user selects
# a specific input/output command than it will "= YES" prompting the script to echo the information previously filled in
if [ "$runindefault" = "yes" -o "$nameinfowanted" = "yes" ]; then
  echo "$nameinfooutput"
fi

if [ "$runindefault" = "yes" -o "$ipinfowanted" = "yes" ]; then
  echo "$ipinfooutput"
fi

if [ "$runindefault" = "yes" -o "$osinfowanted" = "yes" ]; then
  echo "$osinfooutput"
fi

if [ "$runindefault" = "yes" -o "$cpuinfowanted" = "yes" ]; then
  echo "$cpuinfooutput"
fi

if [ "$runindefault" = "yes" -o "$meminfowanted" = "yes" ]; then
  echo "$meminfooutput"
fi

if [ "$runindefault" = "yes" -o "$diskinfowanted" = "yes" ]; then
  echo "$diskinfooutput"
fi

if [ "$runindefault" = "yes" -o "$printinfowanted" = "yes" ]; then
  echo "$printinfooutput"
fi

if [ "$runindefault" = "yes" -o "$softinfowanted" = "yes" ]; then
  echo "$softinfooutput"
fi

#do any cleanup of temporary files if needed
