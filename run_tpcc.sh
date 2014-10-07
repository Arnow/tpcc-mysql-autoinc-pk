#!/bin/bash
## 
## tpcc �Զ����Խű��������ο�
## created by yejr(imysql@imysql.com, http://imysql.com, QQ: 4700963, QQȺ: 125572178��272675472)
## MySQL������: http://imysql.com
## Ҷ����(yejr)
## СҶ������,װ��Linux,д��PHP,�Ż���MySQL,ĿǰΧ����ά�������
## ����΢��: @Ҷ����, ΢�Ź��ں�: MYSQL������
## QQȺ: 125572178��272675472
##

export LD_LIBRARY_PATH=/usr/local/mysql/lib/ 

. ~/.bash_profile

set -u
set -x
set -e

BASEDIR="/opt/yejr/tpcc-mysql"
cd $BASEDIR

exec 3>&1 4>&2 1>> run_tpcc.log 2>&1

DBIP=1.2.3.4
DBPORT=3306
DBUSER='tpcc'
DBPASSWD='tpcc'
NOW=`date +'%Y%m%d%H%M'`
WIREHOUSE=100
DBNAME="tpcc${WIREHOUSE}"
WARMUP=300
DURING=3600

#��ʼ����������
#./tpcc_load $DBIP:$DBPORT $DBNAME $DBUSER $DBPASSWD $WIREHOUSE

for THREADS in 64 128 256 384 512 640 768 896 1024 1152 1280 1408 1536 1664 1792 1920
do

./tpcc_start -h $DBIP -P $DBPORT -d $DBNAME -u $DBUSER -p "${DBPASSWD}" -w $WIREHOUSE -c $THREADS -r $WARMUP -l $DURING > tpcc_${THREADS}_THREADS_${NOW} 2>&1

# ÿ�β����궼Ҫ���� mysqld���ɸ���ʵ��������е����ű�
/etc/ini.t/mysql stop
while [ 1 ] 
do
 if [ ! -z "ps -ef|grep -v grep|grep 'mysqld'" ] ; then
   sleep 60
 fi
done

# ��� OS cache
echo 3 > /proc/sys/vm/drop_caches

# �ٴ����� mysqld
/etc/ini.t/mysql start
sleep 60

done