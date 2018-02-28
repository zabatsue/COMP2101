#!/bin/bash
#This script implements tasks for the bash semester assignment

#Define functions for error messages and display command line help

function displayhelp {
  cat << EOF
  Usage: $0 [-h | --help] [output option...]
    output option can be one or more of the following:
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

function errormessage {
  echo "$@" >&2
}

#Process the command line options, saving the variable for later use
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

#Gathering data into variables

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
#Create the output using the gathered data and command line options

nameinfooutput="System Name and Domain name (If Applicable):

$nameinfo

-----------------------------"

ipinfooutput="IP Address:

$ipinfo

-----------------------------"
osinfooutput="Operating System Information:

$osinfo

-----------------------------"
cpuinfooutput="CPU model:

$cpuinfo

-----------------------------"

meminfooutput="Memory info:

$meminfo

-----------------------------"
diskinfooutput="Disk Space:

$diskinfo

-----------------------------"
printinfooutput="Printer information:

$printinfo

-----------------------------"

softinfooutput="Software Installed:

$softinfo

-----------------------------"

#Display the output
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
