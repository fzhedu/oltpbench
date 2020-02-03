#!/bin/bash

dbType="crdb"
if [ -n "$1" ]
then
	dbType=$1
fi
apThreads="0  16"
if [ -n "$2" ]
then
	apThreads=$2
fi
tpThreads="512"
if [ -n "$3" ]
then
	tpThreads=$3
fi
wd=100
if [ -n "$4" ]
then
	wd=$4
fi

tmpResultDir="results"
if [ -d "$tmpResultDir" ]
then
	echo $tmpResultDir already exists
	exit 1
fi

resultDir=result_${dbType}_wd_${wd}_$(date +%F-%R:%S)
if [ -d "resultDir" ]
then
	echo $resultDir already exists
	exit 1
fi
mkdir $resultDir

for ap in $apThreads
do 
	for tp in $tpThreads
	do
		if [ $dbType = "memsql" ]
		then	
			mysql -uroot -pmemsql -P 3339 -h 127.0.0.1 -e "create database if not exists chbenchmark "

			./oltpbenchmark -b tpcc,chbenchmark -c config/chbenchmark_memsql_load_${wd}.xml --create=true --load=true
			sleep 300
			./oltpbenchmark -b tpcc -c config/chbenchmark_memsql_tp_${tp}_wd_${wd}.xml --execute=true   -o outputfile_memsql_ap_${ap}_tp_${tp}_wd_${wd}_tp &
		
			if [ ${ap} -ne 0 ]
			then
				./oltpbenchmark -b chbenchmark -c config/chbenchmark_memsql_ap_${ap}_wd_${wd}.xml --execute=true   -o outputfile_memsql_ap_${ap}_tp_${tp}_wd_${wd}_ap &
			fi
			wait

			echo "Memsql count of order_line after ap_${ap}_tp_${tp}_wd_${wd}" >> $resultDir/row_count
			mysql -uroot -pmemsql -P 3339 -h 127.0.0.1 -e "select count(*) from chbenchmark.order_line" >> $resultDir/row_count
			mysql -uroot -pmemsql -P 3339 -h 127.0.0.1 -e "drop database if exists chbenchmark"
		elif [ $dbType = "crdb" ]
                then
			psql -U root  -p 26257 -h 172.16.4.41  -c "drop database if exists chbenchmark;"
			psql -U root  -p 26257 -h 172.16.4.41  -c "create database if not exists chbenchmark;"
                        psql -U root  -p 26257 -h 172.16.4.41 -d chbenchmark  -c "IMPORT PGDUMP 'http://172.16.4.41:3000/ch_wd100.sql';"
			psql -U root  -p 26257 -h 172.16.4.41 -d chbenchmark  -c "CREATE INDEX IDX_CUSTOMER_NAME ON customer (c_w_id,c_d_id,c_last,c_first);"
			psql -U root  -p 26257 -h 172.16.4.41 -d chbenchmark  -c "CREATE INDEX idx_order ON oorder (o_w_id,o_d_id,o_c_id,o_id);"
		
                        sleep 100
                        ./oltpbenchmark -b tpcc -c config/chbenchmark_crdb_tp_${tp}_wd_${wd}.xml --execute=true   -o outputfile_crdb_ap_${ap}_tp_${tp}_wd_${wd}_tp &

                        if [ ${ap} -ne 0 ]
                        then
                                ./oltpbenchmark -b chbenchmark -c config/chbenchmark_crdb_ap_${ap}_wd_${wd}.xml --execute=true   -o outputfile_crdb_ap_${ap}_tp_${tp}_wd_${wd}_ap &
                        fi
                        wait

                        echo "crdb count of order_line after ap_${ap}_tp_${tp}_wd_${wd}" >> $resultDir/row_count
                        psql -U root  -p 26257 -h 172.16.4.41  -c "select count(*) from chbenchmark.order_line" >> $resultDir/row_count
                        psql -U root  -p 26257 -h 172.16.4.41  -c "drop database if exists chbenchmark"
		elif [ $dbType = "tidb" ]
		then
			if [ ${ap} -ne 0 ]
			then
				./oltpbenchmark -b tpcc,chbenchmark -c config/chbenchmark_tikv_load_${wd}.xml --create=true --load=true
			else
				./oltpbenchmark -b tpcc,chbenchmark -c config/chbenchmark_tidb_load_${wd}.xml --create=true --load=true
			fi
			ssh 172.16.4.44 "echo \"\" > /data1/xufei/tidb_ansible/log/tiflash.log"
			ssh 172.16.4.69 "echo \"\" > /data1/xufei/tidb_ansible/log/tiflash.log"
			ssh 172.16.5.55 "echo \"\" > /data1/xufei/tidb_ansible/log/tiflash.log"
			./oltpbenchmark -b tpcc -c config/chbenchmark_tidb_tp_${tp}_wd_${wd}.xml --execute=true   -o outputfile_tidb_ap_${ap}_tp_${tp}_wd_${wd}_tp &
			if [ ${ap} -ne 0 ]
			then
				./oltpbenchmark -b chbenchmark -c config/chbenchmark_tispark_ap_${ap}_wd_${wd}.xml --execute=true   -o outputfile_tidb_ap_${ap}_tp_${tp}_wd_${wd}_ap &
			fi
			wait

			echo "TiDB count of order_line after ap_${ap}_tp_${tp}_wd_${wd}" >> $resultDir/row_count
			mysql -uroot -P 4000 -h 172.16.4.75 -e "select count(*) from chbenchmark.order_line" >> $resultDir/row_count
			if [ ${ap} -ne 0 ]
			then
				scp 172.16.4.44:/data1/xufei/tidb_ansible/log/tiflash.log ./$resultDir/tiflash_44.log.ap_${ap}_tp_${tp}
				scp 172.16.4.69:/data1/xufei/tidb_ansible/log/tiflash.log ./$resultDir/tiflash_69.log.ap_${ap}_tp_${tp}
				scp 172.16.5.55:/data1/xufei/tidb_ansible/log/tiflash.log ./$resultDir/tiflash_55.log.ap_${ap}_tp_${tp}
			fi
		else
			echo "dbType should be memsql or tidb"
		fi
	done
done

if [ -d "$tmpResultDir" ]
then 
	mv $tmpResultDir $resultDir
	grep "Average Latency (microseconds)" $resultDir/$tmpResultDir/* >> $resultDir/summary.txt
	grep "Throughput (requests/second)" $resultDir/$tmpResultDir/* >> $resultDir/summary.txt
else
	echo "Failed to find result files, dir $tmpResultDir not exists"
	exit 1
fi
