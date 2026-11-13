#! /bin/sh

## v.1.2022
## This script changes a Users' UID then finds and changes ownership on all files to the new UID/GID
## Choice 2 will change the UID/GID in a specified start directory

## If you prefer to just use the terminal and not this script. The two commands used are:
##   dscl . -change /Users/$USERNAME UniqueID $OLDUID $NEWUID  
##   and
##   find $UPATH -user $OLDUID -print0 | xargs -0 chown -h $NEWUID:$NEWGID

## Make sure you have a root shell by using 'sudo -s' before running these commands

## Also make sure terminal has FULL DISK ACCESS rights:
##   go to System Preferences > Security and Privacy > Privacy > Full Disk Access
##   and make sure that Terminal is checked.

# format text
bold=`tput bold`
normal=`tput sgr0`

# variables
COMPUTERNAME=$(hostname)

# array dirpath is the list of directories this script will recursively check and change UIDs
# you can add additional directory paths under "/private/var" if needed.
declare -a dirpath=("/Users"
                    "/Library"
                    "/Applications"
                    "/usr"
                    "/private/var"
                    )

# set window size
printf '\e[8;20;120t'

# clear screen
clear

# typewriter for start and end of script
function typewriter
{
  text="$1"
  delay="$2"

  for ((i = 0; i < ${#text}; i++)); do
    printf "${text:$i:1}"
    sleep ${delay}
  done
}

# script start
echo #
printf "${bold}>>> CNSD UID:GID Change Script for Mac OS X  <<<" .05
# sleep 0.5
echo #
printf "${bold}>>> Use Ctl-C to quit the Script at any time <<<"
# sleep 0.5
echo #
printf ">>> and make sure to review the README file  <<<" .05
# sleep 1
echo #
echo #

# choose what to run
printf "${normal}Press${bold} 1 ${normal}to run the main ${bold}UID Change Script"
echo #
printf "${normal}Press ${bold}2 ${normal}to change an alternate ${bold}UID"
echo #
printf "> "
read RESPONSE
echo #
# sleep 0.5

# main UID:GID change script
if [ "$RESPONSE" = "1" ] ; then
  # list users
  echo #
  echo "${normal}Here is a listing of the ${bold}/User ${normal}directories on this computer ${bold}$COMPUTERNAME:"
  # sleep 1
  ls /Users
  echo #
  # sleep 1

  # enter username
  printf "${normal}Enter the ${bold}username ${normal}that will have the ${bold}UID ${normal}changed: "
  read USERNAME
  echo #
  # sleep 0.5

  # get old UID
  OLDUID=$(id -u $USERNAME)

  # get old GID
  OLDGID=$(id -g $USERNAME)

  # show user UID:GID
  echo "${bold}$USERNAME ${normal}UID is ${bold}$OLDUID ${normal}and GID is ${bold}$OLDGID"
  echo #
  # sleep 1.2

  # enter new UID
  printf "${normal}Enter the ${bold}new UID${normal}: "
  read NEWUID
  echo #
  # sleep 0.5

  # enter new GID
  printf "${normal}Enter the ${bold}new GID${normal}. ${bold}Note: ${normal}Primary Active Directory group GID is ${bold}15${normal}: "
  read NEWGID
  echo #
  # sleep 0.5

  # list directories in array dirpath at top of script
  printf "${normal}Here are the ${bold}directories ${normal}this script will recursively change UID:GID for ${bold}$USERNAME:"
  # sleep 1.2
  echo #
  for i in "${dirpath[@]}"
  do
    echo "$i"
  done
  echo #
  # sleep 1.2

  # verify changes 1
  printf "${normal}Are you sure ${bold}$USERNAME ${normal}UID:${bold}$OLDUID ${normal}should be changed to UID:${bold}$NEWUID ${normal}and GID:${bold}$OLDGID ${normal}changed to ${bold}$NEWGID?"
  echo #
  # sleep 1.2

  # verify changes 2
  printf "${normal}If this is correct type ${bold}y${normal}, type ${bold}n ${normal}to exit: "
  read RESPONSE
  echo #

  if [ "$RESPONSE" = "y" ] ; then
    # sleep 0.8

    # if yes, change user UID:GID
    echo "${normal}First, let's change the ${bold}UID:GID ${normal}for ${bold}$USERNAME ${normal}to ${bold}$NEWUID:$NEWGID"
    sudo dscl . -change /Users/$USERNAME UniqueID $OLDUID $NEWUID
    sudo dscl . -change /Users/$USERNAME PrimaryGroupID $OLDGID $NEWGID
    echo #
    # sleep 1

    echo "${normal}Change completed"
    echo #
    # sleep 1.2

    # loop through array dirpath
    for i in "${dirpath[@]}"
    do
      echo "${normal}Changing UID ${bold}$OLDUID ${normal}to ${bold}$NEWUID ${nomal}in directory ${bold}$i ${normal}..."
      # sleep 1

      # find old uid | change ownership
      sudo find $i -user $OLDUID -print0 | xargs -0 chown -h $NEWUID:$NEWGID
      # sleep 0.5

      echo "${normal}Done with ${bold}$i"
      # sleep 0.5
    done
    echo #
  elif [ "$RESPONSE" = 'n' ] ; then
    # if no, quit
    printf "No changes made." .04
    echo #
  else
    # if something other than y/n, quit
    printf "No changes made." .04
    echo #
  fi
# Change alternate UID and specify start directory
elif [ "$RESPONSE" = '2' ] ; then

  # enter full path to directory UID change should start at
  printf "${normal}Enter the ${bold}full path ${normal}to the ${bold}start directory${normal}: "
  read UPATH
  # sleep 0.5
  echo #

  while [ ! -d "$UPATH" ]; do
    echo "No such directory path."
    echo #
    # sleep 1
    printf "${normal}Enter the ${bold}full path ${normal}to the ${bold}start directory${normal}: "
    read UPATH
    # sleep 0.5
    echo #
  done

  # list existing UID:GID info
  echo "${normal}The ${bold}UID:GID ${normal}info for ${bold}$UPATH: "
  ls -ln $UPATH
  echo #
  # sleep 1

  printf "${normal}Enter the ${bold}existing UID${normal}: "
  read OLDUID
  echo ""

  printf "${normal}Enter the ${bold}new UID${normal}: "
  read NEWUID
  echo ""

  printf "${normal}Enter the ${bold}new GID${normal}:  "
  read NEWGID
  echo ""

  # verify 1
  echo "${normal}Are you sure UID:${bold}$OLDUID ${normal}should be changed to UID:${bold}$NEWUID ${normal}GID:${bold}$NEWGID${normal} in directory path:${bold}$UPATH${normal}?"
  # sleep 1

  # verify 2
  printf "${normal}If this is correct type ${bold}y${normal}, type ${bold}n ${normal}to exit: "
  read RESPONSE
  echo #

  if [ "$RESPONSE" = "y" ] ; then

    # command to change uid:gid
  	sudo find $UPATH -user $OLDUID -print0 | xargs -0 chown -h $NEWUID:$NEWGID
  elif [ "$RESPONSE" = 'n' ] ; then
  	echo "no changes made"
  else
  	echo "no changes made"
  fi
else
  echo "no changes made"
fi
echo #

# done
typewriter "${normal}The script has finished." .04
# sleep 1.2

echo #
echo #
# echo "A restart is a good idea"
# sleep 1

printf "${normal}restart? ${bold}y/n${normal}: "
read RESPONSE
echo #

if [ "$RESPONSE" = "y" ] ; then
  sudo shutdown -r now
  # sleep 1
  echo #
elif [ "$RESPONSE" = 'n' ] ; then
  # if no, quit
  # sleep 0.5
  # typewriter "exit" .05
  # sleep 0.7
  echo #
else
  # if something other than y/n, quit
  # sleep 1
  # typewriter "exit" .05
  # sleep 0.7
  echo #
fi
