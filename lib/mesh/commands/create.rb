desc 'Create a new virtual machine'
#arg_name 'vm_type'
command :create do |c|
=begin
  c.desc 'Virtual Machine Template over-riding defined platform default'
  c.default_value Mesh::template[:windows]
  c.flag :template
=end
  c.desc 'Destination datastore'
  c.flag :datastore

  c.desc 'Destination Machine IP Address'
  c.flag :ip_address
  c.action do |global_options,options,args|

    ARGV.size >= 2 or abort "must specify VM type and VM target name"
    vm_type = ARGV.shift
    vm_target = ARGV.shift
    @logger.debug "Create invoked to create #{vm_target} of type #{vm_type}\n\t#{global_options}\n\t#{options}\n\t#{args}."
    Mesh::template.has_key? vm_type.to_sym or raise "unknown machine type #{vm_type}, known types are #{Mesh::template.keys.to_s}"
    template = Mesh::template[vm_type.to_sym]

    @logger.debug "create command ran with \n\tArgs:#{args}\n\tOptions:#{options.to_s}\n\tGlobal Options: #{global_options.to_s}"
    @logger.debug @config.inspect
    # VmTemplate.new 
    # VIM = RbVmomi::VIM
    #vim = RbVmomi::VIM.connect global_options
    vm_manager = Mesh::VSphere.new global_options
    #vm_template = Mesh::Machine::Get(vim, global_options[:datacenter], template[:name])
    vm_template = vm_manager.get_machine(template[:name], global_options[:datacenter])
    # TODO spec mgr factory
    #spec_mgr = vim.serviceContent.customizationSpecManager
    #spec = Mesh::CustomSpec::Get(spec_mgr, template[:spec])
    spec = vm_manager.get_custom_spec(template[:spec])
    spec.destination_ip_address = options[:ip_address] if options[:ip_address]
    @logger.debug "Chasing resource pool #{global_options[:resource_pool]}"
    #pool = Mesh::Datacenter::find_pool(vim, global_options[:resource_pool])
    pool = vm_manager.get_resource_pool(global_options[:resource_pool])
    vm_details = vm_target.match /(.+)\/(.+)/
    if vm_details
      vm_folder = vm_details[1]
      vm_name   = vm_details[2]
    else
      vm_folder = '/'
      vm_name   = vm_target
    end
    datacenter = vm_manager.get_datacenter(global_options[:datacenter])
    datastore = vm_manager.get_datastore(options[:datastore], datacenter)
    @logger.debug "Creating vm in folder #{vm_folder} with name #{vm_name}."
    new_vm = vm_template.clone(vm_name, vm_folder, datastore, spec, pool)
    @logger.info "Created new object #{new_vm.inspect}."
  end
end

