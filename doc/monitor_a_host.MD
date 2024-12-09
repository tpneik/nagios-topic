# HOW CAN WE MONITOR A HOST

There are many way to monitor a host. There may method that you can apply to, like using [npre](https://assets.nagios.com/downloads/nagioscore/docs/nagioscore/4/en/addons.html#nrpe), [ncpa](https://www.nagios.org/ncpa/), [nrdp](https://assets.nagios.com/downloads/nagioscore/docs/nagioscore/4/en/monitoring-windows.html#passive),...but all of it are grouped to an agent software. Tht means we need to install it in the target machine (The machine that got monitored). You should pick the solution that match you requirement and system standard. 

But for many reason, we tend to use the most core method because many problem related to security as patching agent software, more install more risk,.... I choose SNMP to use. 

It is an agentless method, one of most original way to monitor system.

## What is SNMP 

## Introduction to working directory of Nagios

When first come to it, we must know what inside the working directory:

```bash
[tpnei@localhost ~]$ cd /usr/local/nagios/
[tpnei@localhost nagios]$ ls
bin  etc  libexec  sbin  share  var
[tpnei@localhost nagios]$ tree .
.
├── bin
│   ├── file2sock
│   ├── log2ndo
│   ├── nagios
│   ├── nagiostats
│   ├── ndo2db
│   ├── ndomod.o
│   └── sockdebug
├── etc
│   ├── cgi.cfg  <-------------------------- Take a look at this
│   ├── htpasswd.users
│   ├── nagios.cfg  <----------------------- Take a look at this
│   ├── ndo2db.cfg
│   ├── ndomod.cfg
│   ├── objects
│   │   ├── commands.cfg
│   │   ├── .....
│   │   ├── timeperiods.cfg
│   │   └── windows.cfg
│   └── resource.cfg
├── libexec
│   ├── check_apt
│   ├── ......
│   ├── utils.pm
│   └── utils.sh
├── sbin
│   ├── archivejson.cgi
│   ├── avail.cgi
│   ├── ....
│   └── trends.cgi
├── share
│   ├── .......
└── var
    ├── archives
    │   └── nagios-12-06-2024-00.log
    ├── nagios.log
    ├── ndo2db.pid
    ├── ndo.sock
    ├── objects.cache
    ├── retention.dat
    ├── rw
    │   ├── nagios.cmd
    │   └── nagios.qh
    ├── spool
    │   └── checkresults
    └── status.dat

27 directories, 483 files
```

If we want to monitor a host/system first we must know about our tool (Nagios in this situation).


### The cgi.cfg (/usr/local/nagios/etc/cgi.cfg)

Its content like:

```apacheconf
main_config_file=/usr/local/nagios/etc/nagios.cfg



# PHYSICAL HTML PATH
# This is the path where the HTML files for Nagios reside.  This
# value is used to locate the logo images needed by the statusmap
# and statuswrl CGIs.

physical_html_path=/usr/local/nagios/share



# URL HTML PATH
# This is the path portion of the URL that corresponds to the
# physical location of the Nagios HTML files (as defined above).
# This value is used by the CGIs to locate the online documentation
# and graphics.  If you access the Nagios pages with an URL like
# http://www.myhost.com/nagios, this value should be '/nagios'
# (without the quotes).

url_html_path=/nagios

```
This configuration file can be considered as **mother configuration file**, because it contain the data about the *another configuration file or html path or the prefix of Nagios GUI,...*. 



### The nagios.cfg (/usr/local/nagios/etc/nagios.cfg)

```apacheconf
# LOG FILE
# This is the main log file where service and host events are logged
# for historical purposes.  This should be the first option specified
# in the config file!!!

log_file=/usr/local/nagios/var/nagios.log



# OBJECT CONFIGURATION FILE(S)
# These are the object configuration files in which you define hosts,
# host groups, contacts, contact groups, services, etc.
# You can split your object definitions across several config files
# if you wish (as shown below), or keep them all in a single config file.

# You can specify individual object config files as shown below:
cfg_file=/usr/local/nagios/etc/objects/commands.cfg
cfg_file=/usr/local/nagios/etc/objects/contacts.cfg
cfg_file=/usr/local/nagios/etc/objects/timeperiods.cfg
cfg_file=/usr/local/nagios/etc/objects/templates.cfg

# Definitions for monitoring the local (Linux) host
cfg_file=/usr/local/nagios/etc/objects/localhost.cfg
```

This is main configuration for Nagios, it define the things like where is log file, and where is the other configuration file, lockfile,...


### The other configuration file

```log
[tpnei@localhost nagios]$ ls ./etc/objects/
commands.cfg  contacts.cfg  localhost.cfg  printer.cfg  switch.cfg  templates.cfg  timeperiods.cfg  windows.cfg
[tpnei@localhost nagios]$ 
```

These have a content that define the thing that you monitor, so, what is **the things**?

The things is :
1. Which host you monitor?
2. How you monitor it?
3. When do Nagios send notification?
4. If send, where the notification will go to?


With the question *Which host you monitor?* --> It is Nginx Reverse Proxy, Dataware House, Bastion Host, Server that contain bussiness service. 

The *How you monitor it?* is the method you choose, It is consider as a command that interact with the system we monitor to get the data. Nagios will execute the command (It can be any script like python/php/bash/c++,...)

Ex: I want to check if the server is still alive or not. I write the bashscript to **ping** the target server, and if the I get **pong**, I know that the sever is alive (It's just a assumption, ping fail does not mean the server died !). The script like:
```psuedo

VAR A = $(PING A SERVER AND GET THE OUT PUT)
CHECK IF 
    A IS PONG (successfully)
        exit 0   <----------- Take a look at this 
    ELSE (failed)
        exit 1   <----------- Take a look at this
```
With the exit data, Nagios will consider it as the status of system currently

| Exit Code | Status | Description |
|-----------|---------|-------------|
| 0 | OK | Service is functioning properly |
| 1 | WARNING | Service is experiencing issues but still functioning |
| 2 | CRITICAL | Service is not functioning properly/not responding |
| 3 | UNKNOWN | Status cannot be determined (plugin error, timeout, etc.) |


The *When do Nagios send notification?* --> We will set the time that Nagios that Nagios send notification base on the monitored system status --> We check every 5 minutes, the command is executed and Nagios get the Status code. Also, if status code is 1, **fire** the "notification", the following exit code is corresponding to

But, *where the notification will go to?*. It must be the the particular channel for nagios to send such as Telegram, Mail, SMS,...

....

