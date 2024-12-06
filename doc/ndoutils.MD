# Setup NDOUTILs

## Overview
### What is it?

### Why do people need it?

### Pros and Cons

## Installing 

First for that, of course we need to have these dependencies. 
```bash
wget http://repo.mysql.com/mysql-community-release-el7-5.noarch.rpm
rpm -ivh mysql-community-release-el7-5.noarch.rpm
yum update
```
Output:

```log
[root@localhost tmp]# wget http://repo.mysql.com/mysql-community-release-el7-5.noarch.rpm
--2024-12-06 02:00:54--  http://repo.mysql.com/mysql-community-release-el7-5.noarch.rpm
Resolving repo.mysql.com (repo.mysql.com)... 23.50.31.204, 2600:1413:b000:78e::1d68, 2600:1413:b000:795::1d68
Connecting to repo.mysql.com (repo.mysql.com)|23.50.31.204|:80... connected.
HTTP request sent, awaiting response... 200 OK
Length: 6140 (6.0K) [application/x-redhat-package-manager]
Saving to: ‘mysql-community-release-el7-5.noarch.rpm’

mysql-community-release-el7-5.noarch.rpm             100%[===================================================================================================================>]   6.00K  --.-KB/s    in 0.003s

2024-12-06 02:00:54 (1.82 MB/s) - ‘mysql-community-release-el7-5.noarch.rpm’ saved [6140/6140]

[root@localhost tmp]# rpm -ivh mysql-community-release-el7-5.noarch.rpm
Verifying...                          ################################# [100%]
Preparing...                          ################################# [100%]
Updating / installing...
   1:mysql-community-release-el7-5    ################################# [100%]
```

And this

```bash
yum install -y mysql mysql-server mysql-devel perl-DBD-MySQL
```

The output:
```log
[root@localhost tmp]# yum install -y mysql mysql-server mysql-devel perl-DBD-MySQL

Last metadata expiration check: 0:41:00 ago on Fri 06 Dec 2024 02:03:30 AM EST.
Dependencies resolved.
=================================================================================================================================================================================================================
 Package                                         Architecture                            Version                                                                Repository                                  Size
=================================================================================================================================================================================================================
Installing:
 mysql                                           x86_64                                  8.0.36-1.module_el8.9.0+3735+82bd6c11                                  appstream                                   14 M
 mysql-devel                                     x86_64                                  8.0.36-1.module_el8.9.0+3735+82bd6c11                                  appstream                                  161 k
 mysql-server                                    x86_64                                  8.0.36-1.module_el8.9.0+3735+82bd6c11                                  appstream                                   32 M
 perl-DBD-MySQL                                  x86_64                                  4.046-3.module_el8.6.0+2827+49d66dc3                                   appstream                                  155 k
Installing dependencies:
 mecab                                           x86_64                                  0.996-2.module_el8.6.0+3340+d764b636                                   appstream                                  392 k
 mysql-common                                    x86_64                                  8.0.36-1.module_el8.9.0+3735+82bd6c11                                  appstream                                  136 k
 mysql-errmsg                                    x86_64                                  8.0.36-1.module_el8.9.0+3735+82bd6c11                                  appstream                                  640 k
 mysql-libs                                      x86_64                                  8.0.36-1.module_el8.9.0+3735+82bd6c11                                  appstream                                  1.5 M
 protobuf-lite                                   x86_64                                  3.5.0-15.el8                                                           appstream                                  148 k
Enabling module streams:
 mysql                                                                                   8.0
 perl-DBD-MySQL                                                                          4.046


Installed:
  mecab-0.996-2.module_el8.6.0+3340+d764b636.x86_64                    mysql-8.0.36-1.module_el8.9.0+3735+82bd6c11.x86_64                    mysql-common-8.0.36-1.module_el8.9.0+3735+82bd6c11.x86_64
  mysql-devel-8.0.36-1.module_el8.9.0+3735+82bd6c11.x86_64             mysql-errmsg-8.0.36-1.module_el8.9.0+3735+82bd6c11.x86_64             mysql-libs-8.0.36-1.module_el8.9.0+3735+82bd6c11.x86_64
  mysql-server-8.0.36-1.module_el8.9.0+3735+82bd6c11.x86_64            perl-DBD-MySQL-4.046-3.module_el8.6.0+2827+49d66dc3.x86_64            protobuf-lite-3.5.0-15.el8.x86_64

Complete!
```

Now when we already have mysql in our system. We start it, make in run on boot.

```bash
systemctl start mysqld.service
systemctl enable mysqld.service
```

The Output:
```log
[root@localhost tmp]# systemctl start mysqld.service
[root@localhost tmp]# systemctl status mysqld.service
● mysqld.service - MySQL 8.0 database server
   Loaded: loaded (/usr/lib/systemd/system/mysqld.service; disabled; vendor preset: disabled)
   Active: active (running) since Fri 2024-12-06 02:51:48 EST; 11s ago
  Process: 146436 ExecStartPost=/usr/libexec/mysql-check-upgrade (code=exited, status=0/SUCCESS)
  Process: 146316 ExecStartPre=/usr/libexec/mysql-prepare-db-dir mysqld.service (code=exited, status=0/SUCCESS)
  Process: 146292 ExecStartPre=/usr/libexec/mysql-check-socket (code=exited, status=0/SUCCESS)
 Main PID: 146392 (mysqld)
   Status: "Server is operational"
    Tasks: 38 (limit: 10796)
   Memory: 482.1M
   CGroup: /system.slice/mysqld.service
           └─146392 /usr/libexec/mysqld --basedir=/usr

Dec 06 02:51:37 localhost.localdomain systemd[1]: Starting MySQL 8.0 database server...
Dec 06 02:51:38 localhost.localdomain mysql-prepare-db-dir[146316]: Initializing MySQL database
Dec 06 02:51:48 localhost.localdomain systemd[1]: Started MySQL 8.0 database server.
[root@localhost tmp]# systemctl enable mysqld.service
Created symlink /etc/systemd/system/multi-user.target.wants/mysqld.service → /usr/lib/systemd/system/mysqld.service.
[root@localhost tmp]#
```


Let's config!

[Warning] A little to taking care of is that I gonna make it most readable and easy to understand, the process must be most simplified. I use the very insecure credential for mysql anyway. So, pay attention to what you are doing with you system. 

We first set the mysql password

```bash
/usr/bin/mysqladmin -u root password 'mypassword' # ---> Do not mimic me haha, It's dump.
```
Yash, after this point, you should check if you action took affect.


```bash
mysql -u root -p'mypassword'

```

Make sure that all of the above part are succesfully. Now we create Database, go to mysql:

```bash
mysql -u root -p'mypassword'
```
Create the database and user for ndoutils to use.
```bash
CREATE DATABASE nagios DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;
CREATE USER 'ndoutils'@'localhost' IDENTIFIED BY 'ndoutils_password';
GRANT USAGE ON *.* TO 'ndoutils'@'localhost'; 
GRANT ALL PRIVILEGES ON nagios.* TO 'ndoutils'@'localhost' WITH GRANT OPTION ; 

FLUSH PRIVILEGE;
```

Now you check you thing you just created succesfully or not.
```bash
echo 'show databases;' | mysql -u ndoutils -p'ndoutils_password' -h localhost
```

The output belike:
```log
Database
information_schema
nagios <--------- It's here
test
```

As I understand currently, NDOUTILS uses Kernel Message Queues which act like a place that receive the data from Nagios and NDOUTILS will take the data from it to perform thing (such as pushing it into mysql).

Queue acts as a buffer between the two processes

So, now we must change the buffer capacity to let NDOUTILS and Nagios have more space to manipulate data. 

We will interact with sysctl.conf file. As documentation, we should backup the 'sysctl.conf' file first. To easy rollback our configuration. 

```bash
cp /etc/sysctl.conf /etc/sysctl.conf_backup
```

Now you open your favorite Text editor, and paste this content to:
```bash
net.ipv4.ip_forward = 0
net.ipv4.conf.default.rp_filter = 1
net.ipv4.conf.default.accept_source_route = 0
kernel.sysrq = 0
kernel.core_uses_pid = 1
net.ipv4.tcp_syncookies = 1
kernel.msgmnb = 131072000
kernel.msgmax = 131072000
kernel.shmmax = 4294967295
kernel.shmall = 268435456
```
Okay. Move to next step, Install the NDOUTILS version you need:
```bash
cd /tmp
wget -O ndoutils.tar.gz https://github.com/NagiosEnterprises/ndoutils/releases/download/ndoutils-x.x.xx/ndoutils-x.x.xx.tar.gz
tar xzf ndoutils.tar.gz
```
cd to the tar-ed file. Now we build the code using the configure script and make command

```bash
./configure
make all
```
The output:

```bash
[root@localhost ndoutils-2.1.4]# ./configure
checking for a BSD-compatible install... /bin/install -c
checking for perl... /bin/perl
checking build system type... x86_64-unknown-linux-gnu
checking host system type... x86_64-unknown-linux-gnu
checking for gcc... gcc
checking whether the C compiler works... yes
checking for C compiler default output file name... a.out
checking for suffix of executables...
checking whether we are cross compiling... no
checking for suffix of object files... o
checking whether we are using the GNU C compiler... yes
checking whether gcc accepts -g... yes
checking for gcc option to accept ISO C89... none needed
checking whether make sets $(MAKE)... yes
.... 

config.status: creating startup/rh-upstart-init
config.status: creating include/config.h


*** Configuration summary for ndoutils 2.1.4 2024-08-01 ***:

 General Options:
 -------------------------
 NDO2DB user:      nagios
 NDO2DB group:     nagios
 NDO2DB tcp port:  5668


Review the options above for accuracy.  If they look
okay, type 'make all' to compile the NDO utilities,
or type 'make' to get a list of make options.

# ------ Make all ----------
[root@localhost ndoutils-2.1.4]# make all
cd ./src && make
make[1]: Entering directory '/tmp/ndoutils-2.1.4/src'
gcc -fPIC -fPIC -g -O2 -I/usr/include/mysql -DHAVE_CONFIG_H  -c -o io.o io.c
gcc -fPIC -fPIC -g -O2 -I/usr/include/mysql -DHAVE_CONFIG_H  -c -o utils.o utils.c
gcc -fPIC -g -O2 -I/usr/include/mysql -DHAVE_CONFIG_H  -o file2sock file2sock.c io.o utils.o   -lm
gcc -fPIC -g -O2 -I/usr/include/mysql -DHAVE_CONFIG_H  -o log2ndo log2ndo.c io.o utils.o   -lm
make ndo2db-2x
make[2]: Entering directory '/tmp/ndoutils-2.1.4/src'
gcc -fPIC -g -O2 -I/usr/include/mysql -DHAVE_CONFIG_H  -c -o db.o db.c
db.c: In function ‘ndo2db_db_hello’:
db.c:265:5: warning: implicit declaration of function ‘asprintf’; did you mean ‘vsprintf’? [-Wimplicit-function-declaration]
  if(asprintf(&buf,"SELECT instance_id FROM %s WHERE instance_name='%s'",ndo2db_db_tablenames[NDO2DB_DBTABLE_INSTANCES],idi->instance_name)==-1)
     ^~~~~~~~
     vsprintf
gcc -fPIC -g -O2 -I/usr/include/mysql -DHAVE_CONFIG_H  -D BUILD_NAGIOS_2X -c -o dbhandlers-2x.o dbhandlers.c
dbhandlers.c: In function ‘ndo2db_get_object_id’:
dbhandlers.c:98:6: warning: implicit declaration of function ‘asprintf’; did you mean ‘vsprintf’? [-Wimplicit-function-declaration]
   if(asprintf(&buf1,"name1 IS NULL")==-1)
      ^~~~~~~~
      vsprintf
gcc -fPIC -g -O2 -I/usr/include/mysql -DHAVE_CONFIG_H   -D BUILD_NAGIOS_2X -o ndo2db-2x queue.c ndo2db.c dbhandlers-2x.o  io.o utils.o db.o     -L/usr/lib64/mysql -lmysqlclient -lpthread -ldl -lssl -lcrypto -l

...
      vsprintf
make[2]: Leaving directory '/tmp/ndoutils-2.1.4/src'
gcc -fPIC -g -O2 -I/usr/include/mysql -DHAVE_CONFIG_H  -o sockdebug sockdebug.c io.o utils.o   -lm
make[1]: Leaving directory '/tmp/ndoutils-2.1.4/src'
```

I remind you not to scare of the warning, It's warning, not a bug! And make install

```bash
[root@localhost ndoutils-2.1.4]# make install
cd ./src && make install
make[1]: Entering directory '/tmp/ndoutils-2.1.4/src'
/bin/install -c -m 775 -d /usr/local/nagios/var
/bin/install -c -m 775 -d /usr/local/nagios/bin
/bin/install -c -m 755 ndo2db-4x /usr/local/nagios/bin/ndo2db
/bin/install -c -m 755 ndomod-4x.o /usr/local/nagios/bin/ndomod.o
/bin/install -c -m 755 file2sock /usr/local/nagios/bin
/bin/install -c -m 755 log2ndo /usr/local/nagios/bin
/bin/install -c -m 755 sockdebug /usr/local/nagios/bin

  Hint: NDOUtils Installation against Nagios v4.x
  completed.

  If you want to install NDOUtils for Nagios v3.x
  please type  'make install-3x

  If you want to install NDOUtils for Nagios v2.x
  please type  'make install-2x


  Next step should be the database initialization/upgrade
  cd into the db/ directory and either:
     ./installdb  (for a new installation) or:
     ./upgradedb  (for an existing one)

make[1]: Leaving directory '/tmp/ndoutils-2.1.4/src'

Main NDOUtils components installed

[root@localhost ndoutils-2.1.4]#
```

Okay now we step to creating DB. There are many field that we may want to use as data for visulizing, but it too much and NDOUTILS developer has give us the script for creating all of it by one hit enter.

```bash
cd db/
./installdb -u 'ndoutils' -p 'ndoutils_password' -h 'localhost' -d nagios
cd .. 
```
The output will be kind of this:
```bash
[root@localhost db]# ./installdb -u 'ndoutils' -p 'ndoutils_password' -h 'localhost' -d nagios
DBD::mysql::db do failed: Table 'nagios.nagios_dbversion' doesn't exist at ./installdb line 52.
** Creating tables for version 2.0.1
     Using mysql.sql for installation...
mysql: [Warning] Using a password on the command line interface can be insecure.
** Updating table nagios_dbversion
Done!
[root@localhost db]#

```
Exactly it is!

Now we take a look at the these file we have now
```bash
[root@localhost db]# ls /usr/local/nagios/
bin  etc  libexec  sbin  share  var
[root@localhost db]# ls /usr/local/nagios/etc/
cgi.cfg  htpasswd.users  nagios.cfg  objects  resource.cfg
[root@localhost db]# ls /usr/local/nagios/etc/objects/
commands.cfg  contacts.cfg  localhost.cfg  printer.cfg  switch.cfg  templates.cfg  timeperiods.cfg  windows.cfg
[root@localhost db]# ls /usr/local/nagios/var/
archives  nagios.log  objects.cache  retention.dat  rw  spool  status.dat
[root@localhost db]# ls /usr/local/nagios/var/rw/
nagios.cmd  nagios.qh
[root@localhost db]#
```

Now there is something to initialize, add the content below to file /usr/local/nagios/etc/ndo2db.cfg

```bash
vi /usr/local/nagios/etc/ndo2db.cfg
```

```log
db_user=ndoutils
db_pass=ndoutils_password
```
Set the sample config:
```bash
[root@localhost ndoutils-2.1.4]# make install-config
/bin/install -c -m 775 -d /usr/local/nagios/etc
/bin/install -c -m 775 -d /usr/local/nagios/var
/bin/install -c -m 644 config/ndo2db.cfg-sample /usr/local/nagios/etc
/bin/install -c -m 644 config/ndomod.cfg-sample /usr/local/nagios/etc

*** Config files installed ***

Remember, these are *SAMPLE* config files.  You'll need to rename
the files in order to use them.
Please read the documentation to know what they are doing.

[root@localhost ndoutils-2.1.4]#
```

We need to take a change a little:

```bash
mv /usr/local/nagios/etc/ndo2db.cfg-sample /usr/local/nagios/etc/ndo2db.cfg
sed -i 's/^db_user=.*/db_user=ndoutils/g' /usr/local/nagios/etc/ndo2db.cfg
sed -i 's/^db_pass=.*/db_pass=ndoutils_password/g' /usr/local/nagios/etc/ndo2db.cfg
mv /usr/local/nagios/etc/ndomod.cfg-sample /usr/local/nagios/etc/ndomod.cfg

```


Now we make the install init 

```bash
make install-init
systemctl enable ndo2db.service
```

The output like:

```bash
[root@localhost ndoutils-2.1.4]# make install-init
/bin/install -c -m 644 startup/default-service /usr/lib/systemd/system/ndo2db.service
[root@localhost ndoutils-2.1.4]# systemctl enable ndo2db.service
Created symlink /etc/systemd/system/multi-user.target.wants/ndo2db.service → /usr/lib/systemd/system/ndo2db.service.

```

Now we check our two service ren or not.

```bash
[root@localhost ndoutils-2.1.4]#
[root@localhost ndoutils-2.1.4]# systemctl status ndo2db.service
● ndo2db.service - Nagios Data Out Daemon
   Loaded: loaded (/usr/lib/systemd/system/ndo2db.service; enabled; vendor preset: disabled)
   Active: active (running) since Fri 2024-12-06 03:29:31 EST; 8s ago
     Docs: http://www.nagios.org/documentation
 Main PID: 149937 (ndo2db)
    Tasks: 1 (limit: 10796)
   Memory: 8.3M
   CGroup: /system.slice/ndo2db.service
           └─149937 /usr/local/nagios/bin/ndo2db -c /usr/local/nagios/etc/ndo2db.cfg -f

Dec 06 03:29:31 localhost.localdomain systemd[1]: Started Nagios Data Out Daemon.
[root@localhost ndoutils-2.1.4]#
[root@localhost ndoutils-2.1.4]#
[root@localhost ndoutils-2.1.4]#
[root@localhost ndoutils-2.1.4]# systemctl status ndo2db.service
● ndo2db.service - Nagios Data Out Daemon
   Loaded: loaded (/usr/lib/systemd/system/ndo2db.service; enabled; vendor preset: disabled)
   Active: active (running) since Fri 2024-12-06 03:29:31 EST; 19s ago
     Docs: http://www.nagios.org/documentation
 Main PID: 149937 (ndo2db)
    Tasks: 1 (limit: 10796)
   Memory: 8.3M
   CGroup: /system.slice/ndo2db.service
           └─149937 /usr/local/nagios/bin/ndo2db -c /usr/local/nagios/etc/ndo2db.cfg -f

Dec 06 03:29:31 localhost.localdomain systemd[1]: Started Nagios Data Out Daemon.
[root@localhost ndoutils-2.1.4]#
```


Yes now it is running!

Now You need to tell nagios that to use the module, you should specifiy it in the configuration file of it. Using this command, it is basically add more line to you nagios.cfg

```bash
printf "\n\n# NDOUtils Broker Module\n" >> /usr/local/nagios/etc/nagios.cfg
printf "broker_module=/usr/local/nagios/bin/ndomod.o config_file=/usr/local/nagios/etc/ndomod.cfg\n" >> /usr/local/nagios/etc/nagios.cfg 
```
First we take a look at out nagios.log reside at /usr/local/nagios/var/nagios.log

```log
[1733461200] LOG ROTATION: DAILY
[1733461200] LOG VERSION: 2.0
[1733461200] CURRENT HOST STATE: localhost;UP;HARD;1;PING OK - Packet loss = 0%, RTA = 0.11 ms
[1733461200] CURRENT SERVICE STATE: localhost;Current Load;OK;HARD;1;OK - load average: 0.45, 0.56, 0.72
[1733461200] CURRENT SERVICE STATE: localhost;Current Users;OK;HARD;1;USERS OK - 3 users currently logged in
[1733461200] CURRENT SERVICE STATE: localhost;HTTP;WARNING;HARD;4;HTTP WARNING: HTTP/1.1 403 Forbidden - 4956 bytes in 0.003 second response time
[1733461200] CURRENT SERVICE STATE: localhost;PING;OK;HARD;1;PING OK - Packet loss = 0%, RTA = 0.14 ms
[1733461200] CURRENT SERVICE STATE: localhost;Root Partition;OK;HARD;1;DISK OK - free space: / 9870 MiB (56.74% inode=98%):
[1733461200] CURRENT SERVICE STATE: localhost;SSH;OK;HARD;1;SSH OK - OpenSSH_8.0 (protocol 2.0)
[1733461200] CURRENT SERVICE STATE: localhost;Swap Usage;OK;HARD;1;SWAP OK - 63% free (1282 MB out of 2047 MB)
[1733461200] CURRENT SERVICE STATE: localhost;Total Processes;OK;HARD;1;PROCS OK: 109 processes with STATE = RSZDT
[1733461963] Auto-save of retention data completed successfully.
[1733465563] Auto-save of retention data completed successfully.
[1733469163] Auto-save of retention data completed successfully.
[1733472763] Auto-save of retention data completed successfully.

```
No need to wondering, keep reading !

Now we restart nagios to make it take affect.

```bash
systemctl restart nagios.service
## check it
systemctl status nagios.service
```

The output:


```bash

[root@localhost ndoutils-2.1.4]# systemctl restart nagios.service
[root@localhost ndoutils-2.1.4]# systemctl status nagios.service
● nagios.service - Nagios Core 4.5.8
   Loaded: loaded (/usr/lib/systemd/system/nagios.service; enabled; vendor preset: disabled)
   Active: active (running) since Fri 2024-12-06 03:36:11 EST; 5s ago
     Docs: https://www.nagios.org/documentation
  Process: 150081 ExecStopPost=/bin/rm -f /usr/local/nagios/var/rw/nagios.cmd (code=exited, status=0/SUCCESS)
  Process: 150080 ExecStop=/bin/kill -s TERM ${MAINPID} (code=exited, status=0/SUCCESS)
  Process: 150085 ExecStart=/usr/local/nagios/bin/nagios -d /usr/local/nagios/etc/nagios.cfg (code=exited, status=0/SUCCESS)
  Process: 150084 ExecStartPre=/usr/local/nagios/bin/nagios -v /usr/local/nagios/etc/nagios.cfg (code=exited, status=0/SUCCESS)
 Main PID: 150087 (nagios)
    Tasks: 6 (limit: 10796)
   Memory: 4.1M
   CGroup: /system.slice/nagios.service
           ├─150087 /usr/local/nagios/bin/nagios -d /usr/local/nagios/etc/nagios.cfg
           ├─150088 /usr/local/nagios/bin/nagios --worker /usr/local/nagios/var/rw/nagios.qh
           ├─150089 /usr/local/nagios/bin/nagios --worker /usr/local/nagios/var/rw/nagios.qh
           ├─150090 /usr/local/nagios/bin/nagios --worker /usr/local/nagios/var/rw/nagios.qh
           ├─150091 /usr/local/nagios/bin/nagios --worker /usr/local/nagios/var/rw/nagios.qh
           └─150094 /usr/local/nagios/bin/nagios -d /usr/local/nagios/etc/nagios.cfg

Dec 06 03:36:11 localhost.localdomain nagios[150087]: ndomod registered for aggregated status data'
Dec 06 03:36:11 localhost.localdomain nagios[150087]: ndomod registered for retention data'
Dec 06 03:36:11 localhost.localdomain nagios[150087]: ndomod registered for contact data'
Dec 06 03:36:11 localhost.localdomain nagios[150087]: ndomod registered for contact notification data'
Dec 06 03:36:11 localhost.localdomain nagios[150087]: ndomod registered for acknowledgement data'
Dec 06 03:36:11 localhost.localdomain nagios[150087]: ndomod registered for state change data'
Dec 06 03:36:11 localhost.localdomain nagios[150087]: ndomod registered for contact status data'
Dec 06 03:36:11 localhost.localdomain nagios[150087]: ndomod registered for adaptive contact data'
Dec 06 03:36:11 localhost.localdomain nagios[150087]: Event broker module '/usr/local/nagios/bin/ndomod.o' initialized successfully.
Dec 06 03:36:11 localhost.localdomain nagios[150087]: Successfully launched command file worker with pid 150094
[root@localhost ndoutils-2.1.4]#
```
As you see, it say that 

```log
ndomod registered for ...
```
We back take a look at the nagios.log

```log
[1733461200] LOG ROTATION: DAILY
[1733461200] LOG VERSION: 2.0
[1733461200] CURRENT HOST STATE: localhost;UP;HARD;1;PING OK - Packet loss = 0%, RTA = 0.11 ms
[1733461200] CURRENT SERVICE STATE: localhost;Current Load;OK;HARD;1;OK - load average: 0.45, 0.56, 0.72
[1733461200] CURRENT SERVICE STATE: localhost;Current Users;OK;HARD;1;USERS OK - 3 users currently logged in
[1733461200] CURRENT SERVICE STATE: localhost;HTTP;WARNING;HARD;4;HTTP WARNING: HTTP/1.1 403 Forbidden - 4956 bytes in 0.003 second response time
[1733461200] CURRENT SERVICE STATE: localhost;PING;OK;HARD;1;PING OK - Packet loss = 0%, RTA = 0.14 ms
[1733461200] CURRENT SERVICE STATE: localhost;Root Partition;OK;HARD;1;DISK OK - free space: / 9870 MiB (56.74% inode=98%):
[1733461200] CURRENT SERVICE STATE: localhost;SSH;OK;HARD;1;SSH OK - OpenSSH_8.0 (protocol 2.0)
[1733461200] CURRENT SERVICE STATE: localhost;Swap Usage;OK;HARD;1;SWAP OK - 63% free (1282 MB out of 2047 MB)
[1733461200] CURRENT SERVICE STATE: localhost;Total Processes;OK;HARD;1;PROCS OK: 109 processes with STATE = RSZDT
[1733461963] Auto-save of retention data completed successfully.
[1733465563] Auto-save of retention data completed successfully.
[1733469163] Auto-save of retention data completed successfully.
[1733472763] Auto-save of retention data completed successfully.
[1733474171] Caught SIGTERM, shutting down...
[1733474171] Caught SIGTERM, shutting down...
[1733474171] Successfully shutdown... (PID=65304)
[1733474171] Nagios 4.5.8 starting... (PID=150087)
[1733474171] Local time is Fri Dec 06 03:36:11 EST 2024
[1733474171] LOG VERSION: 2.0
[1733474171] qh: Socket '/usr/local/nagios/var/rw/nagios.qh' successfully initialized
[1733474171] qh: core query handler registered
[1733474171] qh: echo service query handler registered
[1733474171] qh: help for the query handler registered
[1733474171] wproc: Successfully registered manager as @wproc with query handler
[1733474171] wproc: Registry request: name=Core Worker 150089;pid=150089
[1733474171] wproc: Registry request: name=Core Worker 150090;pid=150090
[1733474171] wproc: Registry request: name=Core Worker 150091;pid=150091
[1733474171] wproc: Registry request: name=Core Worker 150088;pid=150088
[1733474171] ndomod: NDOMOD 2.1.4 (2024-08-01) Copyright (c) 2009 Nagios Core Development Team and Community Contributors
[1733474171] ndomod: Successfully connected to data sink.  0 queued items to flush.
[1733474171] ndomod registered for process data
[1733474171] ndomod registered for timed event data
[1733474171] ndomod registered for log data'
[1733474171] ndomod registered for system command data'
[1733474171] ndomod registered for event handler data'
[1733474171] ndomod registered for notification data'
[1733474171] ndomod registered for service check data'
[1733474171] ndomod registered for host check data'
[1733474171] ndomod registered for comment data'
[1733474171] ndomod registered for downtime data'
[1733474171] ndomod registered for flapping data'
[1733474171] ndomod registered for program status data'
[1733474171] ndomod registered for host status data'
[1733474171] ndomod registered for service status data'
[1733474171] ndomod registered for adaptive program data'
[1733474171] ndomod registered for adaptive host data'
[1733474171] ndomod registered for adaptive service data'
[1733474171] ndomod registered for external command data'
[1733474171] ndomod registered for aggregated status data'
[1733474171] ndomod registered for retention data'
[1733474171] ndomod registered for contact data'
[1733474171] ndomod registered for contact notification data'
[1733474171] ndomod registered for acknowledgement data'
[1733474171] ndomod registered for state change data'
[1733474171] ndomod registered for contact status data'
[1733474171] ndomod registered for adaptive contact data'
[1733474171] Event broker module '/usr/local/nagios/bin/ndomod.o' initialized successfully.
[1733474171] Successfully launched command file worker with pid 150094

```
You can see that more clearly about that it started! Also, the db here we could take some of it to know what happen.

```log
Last login: Thu Dec  5 21:47:39 2024 from 192.168.18.1
[tpnei@localhost ~]$ clear
[tpnei@localhost ~]$ mysql -u root -p
Enter password:
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 15
Server version: 8.0.36 Source distribution

Copyright (c) 2000, 2024, Oracle and/or its affiliates.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql> show databases;
+--------------------+
| Database           |
+--------------------+
| information_schema |
| mysql              |
| nagios             |
| performance_schema |
| sys                |
+--------------------+
5 rows in set (0.00 sec)

mysql>
mysql>
mysql> use nagios;
Reading table information for completion of table and column names
You can turn off this feature to get a quicker startup with -A

Database changed
mysql> show tables;
+----------------------------------------+
| Tables_in_nagios                       |
+----------------------------------------+
| nagios_acknowledgements                |
| nagios_commands                        |
| nagios_commenthistory                  |
| nagios_comments                        |
| nagios_configfiles                     |
| nagios_configfilevariables             |
| nagios_conninfo                        |
| nagios_contact_addresses               |
| nagios_contact_notificationcommands    |
| nagios_contactgroup_members            |
| nagios_contactgroups                   |
| nagios_contactnotificationmethods      |
| nagios_contactnotifications            |
| nagios_contacts                        |
| nagios_contactstatus                   |
| nagios_customvariables                 |
| nagios_customvariablestatus            |
| nagios_dbversion                       |
| nagios_downtimehistory                 |
| nagios_eventhandlers                   |
| nagios_externalcommands                |
| nagios_flappinghistory                 |
| nagios_host_contactgroups              |
| nagios_host_contacts                   |
| nagios_host_parenthosts                |
| nagios_hostchecks                      |
| nagios_hostdependencies                |
| nagios_hostescalation_contactgroups    |
| nagios_hostescalation_contacts         |
| nagios_hostescalations                 |
| nagios_hostgroup_members               |
| nagios_hostgroups                      |
| nagios_hosts                           |
| nagios_hoststatus                      |
| nagios_instances                       |
| nagios_logentries                      |
| nagios_notifications                   |
| nagios_objects                         |
| nagios_processevents                   |
| nagios_programstatus                   |
| nagios_runtimevariables                |
| nagios_scheduleddowntime               |
| nagios_service_contactgroups           |
| nagios_service_contacts                |
| nagios_service_parentservices          |
| nagios_servicechecks                   |
| nagios_servicedependencies             |
| nagios_serviceescalation_contactgroups |
| nagios_serviceescalation_contacts      |
| nagios_serviceescalations              |
| nagios_servicegroup_members            |
| nagios_servicegroups                   |
| nagios_services                        |
| nagios_servicestatus                   |
| nagios_statehistory                    |
| nagios_systemcommands                  |
| nagios_timedeventqueue                 |
| nagios_timedevents                     |
| nagios_timeperiod_timeranges           |
| nagios_timeperiods                     |
+----------------------------------------+
60 rows in set (0.00 sec)

mysql>
```

