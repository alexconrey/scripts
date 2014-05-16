#!/bin/bash
#Execute as root

tempdir=$(/bin/mktemp -d /tmp/systemscan.XXXXXXX)
cd $tempdir
mkdir $tempdir/logs
echo "Files can be found in: "$tempdir
date=$(date +"%m-%d-%y")
starttime=$(date +"%T")
echo "Started at " $starttime


#Maldet Scanner
wget http://www.rfxn.com/downloads/maldetect-current.tar.gz
tar xvfz maldetect-current.tar.gz
maldetdir=$(/bin/ls $tempdir | grep maldet-*)
cd $maldetdir
sh install.sh
screen -S "maldetscan" maldet -a /
cd $tempdir

#Rootkit Checker
wget ftp://ftp.pangeia.com.br/pub/seg/pac/chkrootkit.tar.gz
if [ -f $tmpdir/chkrootkit.tar.gz ] ; then
 tar xvfz $tmpdir/chkrootkit.tar.gz
 chkrootdir=$(/bin/ls $tempdir | grep chkrootkit*)
 cd $chkrootdir
 make
 $tempdir/$chkrootdir/chkrootkit
 cd $tempdir
fi

#ClamAV scanner
arch=$(uname -m)
if [ -f /bin/rpm ] ; then
 echo "CentOS Detected"
 if [ /usr/bin/clamscan ] ; then
  echo "Installing EPEL Software Repository"
  epelrelease="epel-release-6-6.noarch.rpm"
  majorversion=$(/bin/rpm -q --queryformat '%{VERSION}' centos-release)
  if [ $majorversion -eq 5 ] ; then 
   epelrelease="epel-release-5-4.noarch.rpm"
  fi
  if [ $majorversion -eq 6 ] ; then
   epelrelease="epel-release-6-8.noarch.rpm"
  fi
  /bin/rpm -Uvh http://download.fedoraproject.org/pub/epel/$majorversion/$arch/$epelrelease
  /usr/bin/yum install clamav-db clamav clamd
  /sbin/chkconfig clamd on
  /sbin/service clamd start
 fi
fi

if [ -f /usr/bin/apt ] ; then
 echo "Debian/Ubuntu Detected"
 if [ /usr/bin/clamscan ] ; then
  /usr/bin/apt-get install clamav clamav-daemon clamav-freshclam
  /usr/sbin/update-rc.d clamav-daemon defaults
  /usr/sbin/update-rc.d clamav-freshclam defaults
  /usr/sbin/service clamav-daemon start
 fi
fi

/usr/bin/freshclam
/usr/bin/clamscan -ri --exclude-dir=^/sys\|^/proc\|^/dev / --log="$tempdir/logs/clamscan-$date"


stoptime=$(date +"%T")

echo "System Scan Completed. Please check maldet logs."
echo "System Scan started at $starttime"
echo "System Scan completed at $stoptime"
echo "To view maldet logs: maldet -l"
echo "---------------------------"
echo "ClamAV Results"
echo "\n"
cat $tempdir/logs/clamscan-$(date +"%m-%d-%y")
