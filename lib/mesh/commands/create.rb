desc 'Create a new virtual machine'
arg_name 'type folder/name'

command :create do |c|
=begin
  c.desc 'Virtual Machine Template over-riding defined platform default'
  c.default_value Mesh::template[:windows]
  c.flag :template
=end
  c.desc 'Destination datastore, full or partial match'
  c.long_desc 'Destination datastore, full or partial match, partial match will use datastore including the string with the greatest free space'
  c.flag [:s, :datastore]

  c.desc 'Destination Machine IP Address'
  c.flag :ip_address
  c.action do |global_options,options,args|

    ARGV.size >= 2 or abort "must specify VM type and VM target name"
    vm_type = ARGV.shift
    vm_target = ARGV.shift
    @logger.debug "Create invoked to create #{vm_target} of type #{vm_type}\n\t#{global_options[:host]}\n\t#{options}\n\t#{args}."
    Mesh::template.has_key? vm_type.to_sym or raise "unknown machine type #{vm_type}, known types are #{Mesh::template.keys.to_s}"

    @logger.debug "create command ran with \n\tArgs:#{args}\n\tOptions:#{options.to_s}\n\tGlobal Options: #{global_options.to_s}"
    @logger.debug @config.inspect

    template = Mesh::template[vm_type.to_sym]
    vm_dest = Mesh::parse_vm_target vm_target
    vm_manager = Mesh::VSphere.new global_options
    vm_template = vm_manager.get_machine(template[:name], global_options[:datacenter])
    spec = vm_manager.get_custom_spec(template[:spec])
    spec.destination_ip_address = options[:ip_address] if options[:ip_address]
    pool = vm_manager.get_resource_pool(global_options[:resource_pool])
    datacenter = vm_manager.get_datacenter(global_options[:datacenter])
    datastore = vm_manager.get_datastore(options[:datastore], datacenter)
    @logger.debug "Creating vm in folder #{vm_dest[:folder]} with name #{vm_dest[:name]}."
    new_vm = vm_template.clone_to(vm_dest[:name], vm_dest[:folder], datastore, spec, pool)
    @logger.warn "Nil vm returned?" if new_vm.nil?
  end
end

module Mesh
  def self.parse_vm_target(vm_target)
    vm_details = vm_target.match /(.+)\/(.+)/
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

