
desc 'change the power state of the vm'
arg_name 'vm_name [on|off|reset|suspend|destroy]'

command :power do |c|
  c.action do |global_options,options,args|
    ARGV.size >= 2 or abort "must specify VM and a desired state."
    vm_target = ARGV.shift
    desired_state = ARGV.shift
    abort "Invalid desired state #{desired_state}, valid ones are #{Mesh::Machine::valid_states}." unless Mesh::Machine::valid_states.include? desired_state 
    @logger.debug "Power invoked for #{vm_target} with desired state #{desired_state}\n\t#{global_options[:host]}\n\t#{options}\n\t#{args}."

    vm_manager = Mesh::VSphere.new global_options
    vm = vm_manager.get_machine(vm_target, global_options[:datacenter])
    Mesh::logger.debug "Got vm #{vm.name}"

    vm.power desired_state
  end
end
