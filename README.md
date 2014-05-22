## Command suite for VMWare

## What is Mesh?

Mesh is a Command Suite to make managing VMWare components easier and possible without leaving your local machine.

##THIS IS PRE-ALPHA!!!

Mesh is currently Pre-Alpha, hence the 0-dot version; it is susceptible to methods, classes and modules being renamed, added or deleted.

## Setup

  mesh <options here> initcfg

## Usage

To Clone a VM from a template

  mesh create windows myvmname --ip_address='<ip_address>'

  mesh -d 'datacenter' -r 'my_resource_pool' --host vsphere.mydom.com.au create linux 'folder/vmware' --ip_address='10.0.0.2' --datastore='DATASTORE'

To change the power state of a VM

  mesh power 'folder/machine_name' on

  mesh power 'folder/machine_name' off

  mesh power 'folder/machine_name' destroy

## TODOs

* General

  * Define multiple environments in config file, switchable like 'mesh <dc> <action> ...'

  * Server defaults in external configuration, e.g. Symlink to config/shared/ or etcd

* Create

  * Move to destination folder (currently stays in Templates dir)

  * Select datastore based on most free available space

* Power
  
  * Query & output state after operation completes

* Mesh everything else :-)
