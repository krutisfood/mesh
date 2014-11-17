
desc 'revert vm to previous snapshot'
arg_name 'vm_name'

command :revert do |c|
  c.action do |global_options,options,args|
    ARGV.size >= 1 or abort 'must specify VM'
    vm_target = ARGV.shift
    @logger.debug "Revert invoked for #{vm_target}\n\t#{global_options[:host]}\n\t#{options}\n\t#{args}."

    vm_manager = Vmesh::VSphere.new global_options
    vm = vm_manager.get_machine(vm_target, global_options[:datacenter])
    Vmesh::logger.debug "Got vm #{vm.name}"
    vm.revert 
  end
end
