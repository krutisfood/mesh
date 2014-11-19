# Command suite for VMWare

## What is Vmesh?

Vmesh is a Command Suite (think git) to make managing VMWare components easier and possible without leaving your local machine.

##THIS IS ALPHA!

Vmesh is currently Alpha, hence the 0-dot version; it is susceptible to methods, classes and modules being renamed, added or deleted.

**Table of Contents**  *generated with [DocToc](http://doctoc.herokuapp.com/)*

- [Command suite for VMWare](#)
  - [What is Vmesh?](#)
  - [THIS IS ALPHA!](#)
  - [Setup](#)
      - [I don't want to type my connection config every time](#)
      - [How to setup cloning servers](#)
      - [AMG It complains about vtypes and stuff](#)
  - [Usage](#)
    - [Help](#)
    - [Create or clone](#)
          - [IP Handling](#)
          - [How vmesh deals with datastores](#)
    - [Power](#)
        - [Deleting a VM can be done with the command](#)
    - [List](#)
    - [Disk Usage](#)
  - [TODOs](#)
  - [Copyright](#)

## Setup

Install the gem

```
  gem install vmesh
```

You can now start using it, e.g. list top level dirs
```
  vmesh --datacenter=my.datacenter.com --host=my.vcenter.host.com ls
```

#### I don't want to type my connection config every time

Vmesh can save config so you don't have to type it each time, use initconfig with an alias like so

```
  vmesh my_alias --datacenter=my.datacenter.com --host=my.vcenter.host.com initconfig
```

Commands are now as easy as

```
  vmesh my_alias ls
```

#### How to setup cloning servers

Define the image types, their relevant template and any custom specs by editing the `server_defaults.rb` file

```
  lib/vmesh/server_defaults.rb 
```

e.g. an entry similar to
```
  :linux => {
    :name => 'Templates/CENTOS_6',
    :spec => 'Linux No Prompt'
  },
```

then to create a server named `vmlinux01` cloned from `'Templates/CENTOS_6'` template using a custom spec called `Linux No Prompt`

```
  vmesh create vmlinux01 linux
```

#### AMG It complains about vtypes and stuff

* There is (or at least was?) an Rbvmomi hack required for nokogiri breaking change in 1.6.1, I'm still trying to figure the best way around this...

  * https://github.com/vmware/rbvmomi/pull/32


## Usage

### Help

Get help
  
```
  vmesh --help
```

Help on a specific command

```
  vmesh create --help
```

### Create or clone

###### IP Handling

Assuming you have a custom spec defined vmesh can set the IP Address like
```
  vmesh create vmweb01 linux --ip_address='192.168.0.10'
```

When creating multiple servers vmesh automatically increments the IP Address, e.g.
```
  vmesh create "vmweb01,vmweb02" linux --ip_address='192.168.0.10'
```
creates the following servers
|| server name || ip ||
| vmweb01 | 192.168.0.10 |
| vmweb02 | 192.168.0.11 |


###### How vmesh deals with datastores

When specifying datastore vmesh will use a datastore matching name exactly, if it doesn't find a match it will gets all datastores with this string in their name then uses the one with the most free space.

```
  vmesh create my_vm_name2 windows12 [--ip_address='<ip_address>'] --datastore='SEARCH_STRING' [--folder='DESTINATION_FOLDER']
```
e.g. for the above, if datastores exist with names FIRST_SEARCH_STRING, ANOTHER_SEARCH_STRING it will find both (as they both contain "SEARCH_STRING") then use the one with the most free space.


### Power

To change the power state of a VM

```
  vmesh power 'folder/machine_name' on
```

```
  vmesh power 'folder/machine_name' off
```

##### Deleting a VM can be done with the command

```
  vmesh power 'folder/machine_name' destroy
```

### List

_Note_ you can use `ls`, `dir` or `list`

List vms and directories at the top level

```
  vmesh ls
```

List recursively

```
  vmesh ls -r
```

List directories only

```
  vmesh ls -d
```

### Disk Usage

_Note_ you can use `df` or `diskspace`

Display disk usage for all disks at current dc

```
  vmesh df
```

Display disk usage for all disks with 'gold' in the name

```
  vmesh df gold
```

## TODOs

* Sort out problem with upstream rbvmomi/nogokiri

  * Related bug here https://github.com/nsidc/vagrant-vsphere/issues/28

* Create

  * Don't create new vm if less than 10% space

* Power
  
  * Query & display state after operation completes

* General

  * Performance enhancements would be nice

  * Server defaults in external configuration, e.g. Symlink to config/shared/ or etcd

* Vmesh everything else :-)


## Copyright

Copyright (c) 2014 Kurt Gardiner. See LICENSE.txt for further details.


