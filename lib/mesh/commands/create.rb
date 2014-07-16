require 'ipaddr'

desc 'Create a new virtual machine'
arg_name 'type folder/name'

command :create do |c|
  c.desc 'Destination datastore, full or partial match'
  c.long_desc 'Destination datastore, full or partial match, partial match will use datastore including the string with the greatest free space'
  c.flag [:s, :datastore]

  c.desc 'Destination folder'
  c.long_desc 'Destination folder for the vm(s), will be ignored for any vms with a folder supplied as part of the name'
  c.flag [:f, :folder]

  c.desc 'Destination Machine IP Address'
  c.long_desc 'Destination machine IP Address, when creating multiple vms ips will be calculated by incrementing this value'
  c.flag :ip_address
  c.action do |global_options,options,args|

    ARGV.size >= 2 or abort "must specify VM type and VM target name"
    vm_type = ARGV.shift
    vm_targets = ARGV.shift
    @logger.debug "Create invoked to create #{vm_targets} of type #{vm_type}\n\t#{global_options[:host]}\n\t#{options}\n\t#{args}."
    Mesh::template.has_key? vm_type.to_sym or raise "unknown machine type #{vm_type}, known types are #{Mesh::template.keys.to_s}"

    ip_address = options[:ip_address]
    machine_options = {}
    vm_manager = Mesh::VSphere.new global_options
    #default_vm_folder = vm_manager.get_folder(options[:folder]) if options[:folder]
    default_vm_folder = options[:folder] || '/'
    vm_targets.split(',').each do |vm_target|
      machine_options[:ip_address] = ip_address if ip_address.to_s != ''
      machine_options[:datastore] = options[:datastore] if options[:datastore].to_s != ''
      new_vm = vm_manager.clone_machine(vm_type, vm_target, default_vm_folder, machine_options)
      Mesh.logger.info "#{vm_type}, #{vm_target}, #{machine_options}"
      ip_address = IPAddr.new(ip_address).succ.to_s if ip_address.to_s != ''
      Mesh.logger.warn "Check #{vm_target}, nil vm returned..." if new_vm.nil?
    end

=begin
    template = Mesh::template[vm_type.to_sym]
    vm_dest = Mesh::parse_vm_target vm_target
    vm_template = vm_manager.get_machine(template[:name], global_options[:datacenter])
    spec = vm_manager.get_custom_spec(template[:spec])
    spec.destination_ip_address = options[:ip_address] if options[:ip_address]
    pool = vm_manager.get_resource_pool(global_options[:resource_pool], global_options[:datacenter])
    datacenter = vm_manager.get_datacenter(global_options[:datacenter])
    datastore = vm_manager.get_datastore(options[:datastore], datacenter)
    folder = vm_manager.get_folder(vm_dest[:folder])
    raise "No datastore found matching #{options[:datastore]}. Exiting." if datastore.nil?
    @logger.debug "Got datastore named #{datastore.name} with free space #{datastore.free_space}."
    @logger.debug "Creating vm in folder #{vm_dest[:folder]} with name #{vm_dest[:name]}."
    new_vm = vm_template.clone_to(vm_dest[:name], folder, datastore, spec, pool)
    @logger.warn "Nil vm returned?" if new_vm.nil?
=end
  end
end

module Mesh
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
