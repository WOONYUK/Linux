#!/bin/sh
NUM=1
ENTER_LIMIT=3
LOG_BASE_DIR=/var/log/loginchk

echo ""
echo 'Please enter your name in *ALPHABET*.'
echo ""
echo -n "Who are you ? : "
read REALNAME
while [ ! -n "$REALNAME" ]
do
        if [ $NUM -eq $ENTER_LIMIT ]; then
                break
        fi
        echo -n "Enter your name again : "
        read REALNAME
        NUM=`expr $NUM + 1`
done
if [ ! -n "$REALNAME" ]; then
        exit
fi
TTY=`tty`
TTY=`echo $TTY | sed -e "s/\/dev\///"`
DATE=`date +'%y%m%d%H%M%S'`
LOGFILE=$LOG_BASE_DIR/logincheck_${DATE}_${REALNAME}_$$.log
DATE=`date +'%Y/%m/%d %H:%M:%S'`
echo "Logging Start by $REALNAME at $DATE" >> $LOGFILE
last | /bin/grep -E "$TTY" | head -1 | awk '{print "login_user:"$1,"tty:"$2,"come_from:"$3}' >> $LOGFILE
echo "" >> $LOGFILE
script -a $LOGFILE
echo "" >> $LOGFILE
DATE=`date +'%Y/%m/%d %H:%M:%S'`
echo "Logging End by $REALNAME at $DATE" >> $LOGFILE
exit
