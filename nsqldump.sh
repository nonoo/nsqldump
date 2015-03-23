#!/bin/sh
self=`readlink "$0"`
if [ -z "$self" ]; then
	self=$0
fi
scriptname=`basename "$self"`
scriptdir=${self%$scriptname}

. $scriptdir/config
. $nlogrotatepath/redirectlog.src.sh

if [ "$1" = "quiet" ]; then
	quietmode=1
	redirectlog
fi

checklogsize

mysqldump -u $mysqluser -p$mysqlpass --all-databases | gzip -9 > $dstpath/`hostname`-sqldump-`date +%Y%m%d`.sql.gz
if [ $? -ne 0 ]; then
    eval $senderrormailcommand
fi
find $dstpath/* -mtime +$deleteafterdays -exec rm {} \;
