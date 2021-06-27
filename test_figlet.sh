#!/bin/sh

PACKAGE="figlet"

EPMLOG=/var/log/package-update

GITDIR=/usr/local/git
ETCDIR=$GITDIR/etc
BINDIR=$GITDIR/bin
SBINDIR=$GITDIR/sbin
OEMDIR=$GITDIR/oem/host
EMDIR=$GITDIR/em/host
TIMEOUT=$OEMDIR/timeout

PACKAGEUPDATE=$GITDIR/bin/package-update
CC="tools-test"

PATH=$PATH:$GITDIR/bin:/bin:/usr/bin:/usr/sbin:/usr/local/bin
export PATH

export TERM=vt100

HOST=$(uname -n)
OS=$(uname -s)

BACKUP=$(date +%Y%m%d%H%M)

[[ -f $EPMLOG ]] && mv $EPMLOG ${EPMLOG}.$BACKUP

echo "
	------------------------------------------------
	  Start testing $PACKAGE package now
	------------------------------------------------
	"

echo "
### Testing Procedure 1 - remove package now
### Running - $GITDIR/etc/software/$PACKAGE.remove now
	"                  

if [[ -f $GITDIR/etc/software/$PACKAGE.remove ]]
then
   $GITDIR/etc/software/$PACKAGE.remove now
fi

echo "
### Testing Procedure 2 - install current production package
### Running - $PACKAGEUPDATE $PACKAGE
	"                  

$PACKAGEUPDATE $PACKAGE

echo "
### Testing Procedure 3 - testing upgrade new package
### Running - $PACKAGEUPDATE $PACKAGE -cc=$CC
	"                  

$PACKAGEUPDATE $PACKAGE -cc=$CC

echo "
### Testing Procedure 4 - testing remove new package
### Running - $GITDIR/etc/software/$PACKAGE.remove now
	"                  

$GITDIR/etc/software/$PACKAGE.remove now

echo "
### Testing Procedure 5 - testing reinstall new package 
### Running - $PACKAGEUPDATE $PACKAGE -cc=$CC
	"                  

$PACKAGEUPDATE $PACKAGE -cc=$CC

echo "
### Testing Procedure 6 - check package-update log file
### Running - cat $EPMLOG
        "                  

cat $EPMLOG

echo "
### Testing Procedure 7 - check permissions and ownership for all directories
### Running - ls -ld $GITDIR $BINDIR
        "

ls -ld $GITDIR $BINDIR

echo "
### Testing Procedure 8 - check permissions and ownership for all files
### Running - ls -lt $GITDIR $BINDIR
	"                  

ls -lt $GITDIR $BINDIR


echo "
### Testing Case 3 - Verify figlet is installed
### Running - sudo apt list --installed |grep figlet 
	"                  

sudo apt list --installed|grep figlet
echo $?

echo "
        ----------------------------------------------
          Finish testing $PACKAGE package
        ----------------------------------------------
        "

