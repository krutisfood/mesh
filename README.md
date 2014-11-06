# Command suite for VMWare

## What is Vmesh?

Vmesh is a Command Suite (think git) to make managing VMWare components easier and possible without leaving your local machine.

##THIS IS ALPHA!

Vmesh is currently Alpha, hence the 0-dot version; it is susceptible to methods, classes and modules being renamed, added or deleted.

## Setup

* Rbvmomi hack required for nokogiri breaking change in 1.6.1

  * https://github.com/vmware/rbvmomi/pull/32

* get the gem (if it exists) or just clone the repo if it doesn't.  If working in the repo prefix all commands with "bundle exec "

```
  vmesh <options_here> initconfig
```

To setup multiple connections use the form

```
  vmesh <site_name> <options_here> initconfig
```

Edit the config file to set your available image types and the corresponding vm template to use in cloning, any relevant custom specs.  One day this will move externally, perhaps etcd and/or a config file able to be specified on command line.
```
  lib/vmesh/server_defaults.rb 
```

## Usage

### Help

To get help
  
```
  vmesh --help
```

Help on a specific command

```
  vmesh create --help
```

### Create or clone

To Clone VM(s) from a template, assigning ips starting at <ip_address>, datastore will use a datastore with exact match, if none exists it will find all datastores which contain this string and use the one with the most free space.

```
  vmesh [host_alias] create my_vm_name1,my_vm_name2 <type> [--ip_address='<ip_address>'] --datastore='SEARCH_STRING' [--folder='DESTINATION_FOLDER']
```
e.g. for the above, if datastores exist with names FIRST_SEARCH_STRING, ANOTHER_SEARCH_STRING it will find both (as they both contain "SEARCH_STRING") then use the one with the most free space.

### Power

To change the power state of a VM

```
  vmesh [host_alias] power 'folder/machine_name' on
```

```
  vmesh [host_alias] power 'folder/machine_name' off
```

```
  vmesh [host_alias] power 'folder/machine_name' destroy
```

### List

To list all vms and directories on default host

```
  vmesh [host_alias] list|ls|dir
```

List directories only

```
  vmesh [host_alias] list|ls|dir -d 
```

## TODOs

* Sort out problem with upstream rbvmomi/nogokiri

  * Related bug here https://github.com/nsidc/vagrant-vsphere/issues/28

* Create

  * Don't create new vm if less than 10% space

* List 

  * Non-recursive listing

* Power
  
  * Query & display state after operation completes

* General

  * Performance enhancements would be nice

  * Server defaults in external configuration, e.g. Symlink to config/shared/ or etcd

* Vmesh everything else :-)


## Copyright

Copyright (c) 2014 Kurt Gardiner. See LICENSE.txt for further details.


