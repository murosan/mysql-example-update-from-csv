#!/bin/bash -e

dir=$(cd $(dirname $0); pwd)
csv_data=${dir}/data.csv

db_host=127.0.0.1
db_port=3306
db_name=test
db_pass=mysql
cmd_mysql="mysql --local-infile=1 -h ${db_host} --port ${db_port} -u root -p${db_pass} ${db_name}"

# csvからupdate
table_name=users
tmp_db_name=tmp
unique=id
update1=name
${cmd_mysql} -e "create table ${tmp_db_name} like ${table_name};"
${cmd_mysql} -e "
load data local infile '${csv_data}'
into table ${tmp_db_name} fields terminated by ','
(${unique}, ${update1})
"
${cmd_mysql} -e "
update ${table_name}
inner join ${tmp_db_name}
  on ${tmp_db_name}.${unique}=${table_name}.${unique}
  set ${table_name}.${update1}=${tmp_db_name}.${update1};
"
${cmd_mysql} -e "drop table ${tmp_db_name};"
