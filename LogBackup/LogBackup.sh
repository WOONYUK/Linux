#!/bin/sh
#
# logbackup.shから実行される
# 前日分のシスログをバクアップディレクトリにコピーする
#

HOSTNAME=`hostname`
DATE=`date -d "1 day ago" +%Y%m%d`
DATE_YEAR=`date -d "1 day ago" +%Y`
DATE_MONTH=`date -d "1 day ago" +%m`
DATE_DAY=`date -d "1 day ago" +%d`
BK_DIR='/backup'
SYSLOG_DIR='/var/log'

logger -t $0 -i "START"

# バックアップDIR確認
if [ ! -d "${BK_DIR}/${DATE_YEAR}/${DATE_MONTH}/${DATE_DAY}" ]; then
        logger -t $0 -i "BackupDIR is Not Found"
        exit
fi

cd ${BK_DIR}/${DATE_YEAR}/${DATE_MONTH}/${DATE_DAY}
mkdir syslog

# syslogバックアップ
cd ${SYSLOG_DIR}
cp cron-${DATE}.gz ${BK_DIR}/${DATE_YEAR}/${DATE_MONTH}/${DATE_DAY}/syslog/
        if [ ! $? = 0 ]; then
                logger -t $0 -i "ERROR: cron-${DATE}.gz Copy Faild"
        fi
cp messages-${DATE}.gz ${BK_DIR}/${DATE_YEAR}/${DATE_MONTH}/${DATE_DAY}/syslog/
        if [ ! $? = 0 ]; then
                logger -t $0 -i "ERROR: messages-${DATE}.gz Copy Faild"
        fi
cp secure-${DATE}.gz ${BK_DIR}/${DATE_YEAR}/${DATE_MONTH}/${DATE_DAY}/syslog/
        if [ ! $? = 0 ]; then
                logger -t $0 -i "ERROR: secure-${DATE}.gz Copy Faild"
        fi

logger -t $0 -i "END"
