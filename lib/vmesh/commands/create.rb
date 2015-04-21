require 'ipaddr'

desc 'create a new virtual machine'
arg_name 'folder/name[,folder/name_of_second_machine] type'

command :create do |c|
  c.desc 'Destination datastore, full or partial match'
  c.long_desc 'Destination datastore, full or partial match, partial match will use datastore including the string with the greatest free space'
  c.flag [:s, :datastore]

  c.desc 'Destination folder where not supplied with name'
  c.long_desc 'Destination folder for the vm(s), will be ignored for any vms with a folder supplied as part of the name'
  c.flag [:f, :folder]

# This wasn't working for what-ever reason, no error, just no effect
  #c.desc 'Number of CPUs'
  #c.long_desc 'Number of CPUs'
  #c.flag [:c, :cpus]
#
  #c.desc 'MB of RAM'
  #c.long_desc 'MB of RAM'
  #c.flag [:r, :ramMB]

  c.desc 'Destination Machine IP Address'
  c.long_desc 'Destination machine IP Address, when creating multiple vms ips will be calculated by incrementing this value'
  c.flag :ip_address
  c.action do |global_options,options,args|

    ARGV.size >= 2 or abort "must specify VM target name and VM type"
    vm_targets = ARGV.shift
    vm_type = ARGV.shift
    @logger.debug "Create invoked to create #{vm_targets} of type #{vm_type}\n\t#{global_options[:host]}\n\t#{options}\n\t#{args}."
    Vmesh::template.has_key? vm_type.to_sym or raise "unknown machine type #{vm_type}, known types are #{Vmesh::template.keys.to_s}"

    ip_address = options[:ip_address]
    if ip_address.to_s != ''
      raise RuntimeError, "IP Address #{ip_address} already in use" if Vmesh::pingecho(ip_address, 1)
    end
    machine_options = {}
    vm_manager = Vmesh::VSphere.new global_options
    #default_vm_folder = vm_manager.get_folder(options[:folder]) if options[:folder]
    default_vm_folder = options[:folder] || '/'
    vm_targets.split(',').each do |vm_target|
      machine_options[:ip_address] = ip_address if ip_address.to_s != ''
      machine_options[:datastore] = options[:datastore] if options[:datastore].to_s != ''
      machine_options[:memoryMB] = options[:ramMB] if options[:ramMB].to_s != ''
      machine_options[:numCPUs] = options[:cpus] if options[:cpus].to_s != ''
      new_vm = vm_manager.clone_machine(vm_type, vm_target, default_vm_folder, machine_options)
      Vmesh.logger.info "#{vm_type}, #{vm_target}, #{machine_options}"
      ip_address = IPAddr.new(ip_address).succ.to_s if ip_address.to_s != ''
      Vmesh.logger.warn "Check #{vm_target}, nil vm returned..." if new_vm.nil?
    end
  end
end

module Vmesh
  def self.parse_vm_target(vm_target)
    vm_details = vm_target.match(/(.+)\/(.+)/)
    vm = Hash.new
    vm[:folder] = '/'
    vm[:name]   = vm_target
    if vm_details
      vm[:folder] = vm_details[1]
      vm[:name]   = vm_details[2]
    end
    vm
  end
end
