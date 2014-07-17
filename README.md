# Command suite for VMWare

## What is Mesh?

Mesh is a Command Suite (think git) to make managing VMWare components easier and possible without leaving your local machine.

##THIS IS ALPHA!

Mesh is currently Alpha, hence the 0-dot version; it is susceptible to methods, classes and modules being renamed, added or deleted.

## Setup

* get the gem (if it exists) or just clone the repo if it doesn't.  If working in the repo prefix all commands with "bundle exec "

```
  mesh <options_here> initconfig
```

To setup multiple connections use the form

```
  mesh <site_name> <options_here> initconfig
```

## Usage

### Help

To get help
  
```
  mesh --help
```

Help on a specific command

```
  mesh create --help
```

### Create or clone

To Clone VM(s) from a template, assigning ips starting at <ip_address>, datastore will use a datastore with exact match, if none exists it will find all datastores which contain this string and use the one with the most free space.

```
  mesh [host_alias] create windows my_vm_name1,my_vm_name2 [--ip_address='<ip_address>'] --datastore='SEARCH_STRING' [--folder='DESTINATION_FOLDER']
```
e.g. for the above, if datastores exist with names FIRST_SEARCH_STRING, ANOTHER_SEARCH_STRING it will find both (as they both contain "SEARCH_STRING") then use the one with the most free space.

### Power

To change the power state of a VM

```
  mesh [host_alias] power 'folder/machine_name' on
```

```
  mesh [host_alias] power 'folder/machine_name' off
```

```
  mesh [host_alias] power 'folder/machine_name' destroy
```

### List

To list all vms and directories on default host

```
  mesh [host_alias] list|ls|dir
```

List directories only

```
  mesh [host_alias] list|ls|dir -d 
```

## TODOs

* List 

  * Non-recursive listing

* Power
  
  * Query & display state after operation completes

* General

  * Performance enhancements would be nice

  * Server defaults in external configuration, e.g. Symlink to config/shared/ or etcd

* Mesh everything else :-)


## Copyright

Copyright (c) 2014 Kurt Gardiner. See LICENSE.txt for further details.


