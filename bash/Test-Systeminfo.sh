#!/bin/bash
#This script implements tasks for the bash semester assignment

#Define functions for error messages and display command line help

function displayhelp {
  cat << EOF
  Usage: $0 [-h | --help] [output option...]
    output option can be one or more of the following:
    -n | --namesinfo
    -i | --ipinfo
    -o | --osinfo
    -c | --cpuinfo
    -m | --meminfo
    -d | --diskinfo
    -p | --printinfo
    -s | --softinfo
EOF
}

function errormessage {
  echo "$@" >&2
}

#Process the command line options, saving the variable for later use
rundefault="yes"
while [ $# -gt 0 ]; do
  case "$1" in
    -h|--help)
      displayhelp
      exit 0
      ;;
    -n|--namesinfo)
      namesinfowanted="yes"
      rundefault="no"
      ;;
    -i|--ipaddress)
      ipinfowanted="yes"
      rundefault="no"
      ;;
    -o|--osinfo)
      osinfowanted="yes"
      rundefault="no"
      ;;
    -c|--cpuinfo)
      cpuinfowanted="yes"
      rundefault="no"
      ;;
    -m|--memory)
      meminfowanted="yes"
      rundefault="no"
      ;;
    -d|--diskinfo)
      diskinfowanted="yes"
      rundefault="no"
      ;;
    -p|--printinfo)
      printinfowanted="yes"
      rundefault="no"
      ;;
    -s|--softinfo)
      softinfowanted="yes"
      rundefault="no"
      ;;
    *)
      errormessage "I don't recognize '$1'"
      errormessage "$(displayhelp)"
      exit 1
      ;;
  esac
  shift
done

#Gather the data into variables, using arrays where helpful

if [ "$rundefault" = "yes" -o "$namesinfowanted" = "yes" ]; then
  namesinfo="$(hostname && domainname)"
fi

if [ "$rundefault" = "yes" -o "$ipinfowanted" = "yes" ]; then
  ipinfo="$(ip -o address | grep "ens33" | sed -n '1p' | awk '{print $4;}')"
fi

if [ "$rundefault" = "yes" -o "$osinfowanted" = "yes" ]; then
  osinfo="$(grep PRETTY /etc/os-release | sed -e 's/.*=//' -e 's/\"//g')"
fi

if [ "$rundefault" = "yes" -o "$cpuinfowanted" = "yes" ]; then
  cpuinfo="$(lscpu | grep 'Model name' | sed -e 's/.*://' -e 's/^[ \t]*//')"
fi

if [ "$rundefault" = "yes" -o "$meminfowanted" = "yes" ]; then
  meminfo="$(free -m | head -2)"
fi

if [ "$rundefault" = "yes" -o "$diskinfowanted" = "yes" ]; then
  diskinfo="$(df -h / | awk '{print $2,$3,$4;}')"
fi

if [ "$rundefault" = "yes" -o "$printinfowanted" = "yes" ]; then
  printinfo="$(lpstat -p)"
fi

if [ "$rundefault" = "yes" -o "$softinfowanted" = "yes" ]; then
  softinfo="$(dpkg --get-selections)"
fi
#Create the output using the gathered data and command line options

namesinfooutput="System and Domain name:
-----------------------------
$namesinfo
-----------------------------"
ipinfooutput="IP Address:
-----------------------------
$ipinfo
-----------------------------"
osinfooutput="Operating System Information:
-----------------------------
$osinfo
-----------------------------"
cpuinfooutput="CPU model:
-----------------------------
$cpuinfo
-----------------------------"
meminfooutput="Memory info:
-----------------------------
$meminfo
-----------------------------"
diskinfooutput="Disk Space:
-----------------------------
$diskinfo
-----------------------------"
printinfooutput="Printer information:
-----------------------------
$printinfo
-----------------------------"
softinfooutput="Software Installed:
-----------------------------
$softinfo
-----------------------------"

#Display the output
if [ "$rundefault" = "yes" -o "$namesinfowanted" = "yes" ]; then
  echo "$namesinfooutput"
fi

if [ "$rundefault" = "yes" -o "$ipinfowanted" = "yes" ]; then
  echo "$ipinfooutput"
fi

if [ "$rundefault" = "yes" -o "$osinfowanted" = "yes" ]; then
  echo "$osinfooutput"
fi

if [ "$rundefault" = "yes" -o "$cpuinfowanted" = "yes" ]; then
  echo "$cpuinfooutput"
fi

if [ "$rundefault" = "yes" -o "$meminfowanted" = "yes" ]; then
  echo "$meminfooutput"
fi

if [ "$rundefault" = "yes" -o "$diskinfowanted" = "yes" ]; then
  echo "$diskinfooutput"
fi

if [ "$rundefault" = "yes" -o "$printinfowanted" = "yes" ]; then
  echo "$printinfooutput"
fi

if [ "$rundefault" = "yes" -o "$softinfowanted" = "yes" ]; then
  echo "$softinfooutput"
fi
#do any cleanup of temporary files if needed
