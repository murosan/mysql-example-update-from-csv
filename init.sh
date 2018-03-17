#!/bin/bash -e

dir=$(cd $(dirname $0); pwd)
sql_create=${dir}/create_tables.sql

db_host=127.0.0.1
db_port=3306
db_name=test
db_pass=mysql
cmd_base="mysql --local-infile=1 -h ${db_host} --port ${db_port} -u root -p${db_pass}"
${cmd_base} -e "create database ${db_name};"
cmd_mysql="${cmd_base} ${db_name}"

table_name=users
${cmd_mysql} -e "
create table ${table_name} (
  id int(2) unsigned not null auto_increment,
  age tinyint unsigned not null,
  name varchar(11) not null default '',
  primary key (id)
) engine=InnoDB default charset=utf8;

insert into users (id, age, name)
values
  (1, 10, 'user1'),
  (2, 20, 'user2'),
  (3, 30, 'user3'),
  (4, 40, 'user4');
"
