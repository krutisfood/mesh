desc 'Create a new virtual machine'
#arg_name 'vm_type'
command :create do |c|
=begin
  c.desc 'Virtual Machine Template over-riding defined platform default'
  c.default_value Mesh::template[:windows]
  c.flag :template
=end
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
    @logger.debug "Getting VIM connection"
    vim = RbVmomi::VIM.connect global_options
    vm_template = Mesh::Machine::Get(vim, global_options[:datacentre], template[:name])
    # TODO spec mgr  factory
    spec_mgr = vim.serviceContent.customizationSpecManager
    spec = Mesh::CustomSpec::Get(spec_mgr, template[:spec])
    spec.destination_ip_address = options[:ip_address] if options[:ip_address]
    @logger.debug "Chasing resource pool #{resource_pool}"
    pool = Datacentre::find_pool(vim, global_options[:resource_pool])
    new_vm = vm_template.clone(vm_target, spec, pool)
    @logger.debug new_vm.inspect
  end
end

