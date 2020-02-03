#!/bin/bash
######## for tidb

#./oltpbenchmark -b tpcc,chbenchmark -c config/chbenchmark_tidb_load_10.xml --create=true --load=true

#./oltpbenchmark -b tpcc -c config/chbenchmark_tidb_tp_10_wd_10.xml --execute=true -s 5 -o outputfile_tidb_tp_ap_5_tp_10_wd_10 &
#./oltpbenchmark -b chbenchmark -c config/chbenchmark_tispark_ap_5_wd_10.xml --execute=true -s 5 -o outputfile_tidb_ap_ap_5_tp_10_wd_10 &
#wait

#./oltpbenchmark -b tpcc,chbenchmark -c config/chbenchmark_tidb_load_10.xml --create=true --load=true
#./oltpbenchmark -b tpcc -c config/chbenchmark_tidb_tp_50_wd_10.xml --execute=true -s 5 -o outputfile_tidb_tp_ap_5_tp_50_wd_10 &
#./oltpbenchmark -b chbenchmark -c config/chbenchmark_tispark_ap_5_wd_10.xml --execute=true -s 5 -o outputfile_tidb_ap_ap_5_tp_50_wd_10 &
#wait

#./oltpbenchmark -b tpcc,chbenchmark -c config/chbenchmark_tidb_load_10.xml --create=true --load=true
#./oltpbenchmark -b tpcc -c config/chbenchmark_tidb_tp_100_wd_10.xml --execute=true -s 5 -o outputfile_tidb_tp_ap_5_tp_100_wd_10 &
#./oltpbenchmark -b chbenchmark -c config/chbenchmark_tispark_ap_5_wd_10.xml --execute=true -s 5 -o outputfile_tidb_ap_ap_5_tp_100_wd_10 &
#wait

######### for memsql
#./oltpbenchmark -b tpcc,chbenchmark -c config/chbenchmark_memsql_load_10.xml --create=true --load=true
#./oltpbenchmark -b tpcc -c config/chbenchmark_memsql_tp_10_wd_10.xml --execute=true -s 5 -o outputfile_memsql_tp_ap_5_tp_10_wd_10 &
#./oltpbenchmark -b chbenchmark -c config/chbenchmark_memsql_ap_5_wd_10.xml --execute=true -s 5 -o outputfile_memsql_ap_ap_5_tp_10_wd_10 &
#wait

#./oltpbenchmark -b tpcc,chbenchmark -c config/chbenchmark_memsql_load_10.xml --create=true --load=true
#./oltpbenchmark -b tpcc -c config/chbenchmark_memsql_tp_50_wd_10.xml --execute=true -s 5 -o outputfile_memsql_tp_ap_5_tp_50_wd_10 &
#./oltpbenchmark -b chbenchmark -c config/chbenchmark_memsql_ap_5_wd_10.xml --execute=true -s 5 -o outputfile_memsql_ap_ap_5_tp_50_wd_10 &
#wait

#./oltpbenchmark -b tpcc,chbenchmark -c config/chbenchmark_memsql_load_10.xml --create=true --load=true
#./oltpbenchmark -b tpcc -c config/chbenchmark_memsql_tp_100_wd_10.xml --execute=true -s 5 -o outputfile_memsql_tp_ap_5_tp_100_wd_10 &
#./oltpbenchmark -b chbenchmark -c config/chbenchmark_memsql_ap_5_wd_10.xml --execute=true -s 5 -o outputfile_memsql_ap_ap_5_tp_100_wd_10 &
#wait

######### for crdb
./oltpbenchmark -b chbenchmark -c config/chbenchmark_crdb_load_100.xml --create=true --load=true
./oltpbenchmark -b tpcc -c config/tpcc_crdb_load_100.xml --create=true --load=true
./oltpbenchmark -b tpcc -c config/chbenchmark_crdb_tp_10_wd_100.xml --execute=true -s 5 -o outputfile_crdb_tp_ap_5_tp_10_wd_100 &
./oltpbenchmark -b chbenchmark -c config/chbenchmark_crdb_ap_5_wd_100.xml --execute=true -s 5 -o outputfile_crdb_ap_ap_5_tp_10_wd_100 &
wait

./oltpbenchmark -b chbenchmark -c config/chbenchmark_crdb_load_100.xml --create=true --load=true
./oltpbenchmark -b tpcc -c config/tpcc_crdb_load_100.xml --create=true --load=true
./oltpbenchmark -b tpcc -c config/chbenchmark_crdb_tp_50_wd_100.xml --execute=true -s 5 -o outputfile_crdb_tp_ap_5_tp_50_wd_100 &
./oltpbenchmark -b chbenchmark -c config/chbenchmark_crdb_ap_5_wd_100.xml --execute=true -s 5 -o outputfile_crdb_ap_ap_5_tp_50_wd_100 &
wait

./oltpbenchmark -b chbenchmark -c config/chbenchmark_crdb_load_100.xml --create=true --load=true
./oltpbenchmark -b tpcc -c config/tpcc_crdb_load_100.xml --create=true --load=true
./oltpbenchmark -b tpcc -c config/chbenchmark_crdb_tp_100_wd_100.xml --execute=true -s 5 -o outputfile_crdb_tp_ap_5_tp_100_wd_100 &
./oltpbenchmark -b chbenchmark -c config/chbenchmark_crdb_ap_5_wd_100.xml --execute=true -s 5 -o outputfile_crdb_ap_ap_5_tp_100_wd_100 &
wait
