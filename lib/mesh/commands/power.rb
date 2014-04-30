desc 'Change Power state of an existing VM'
arg_name 'vm_name [on|off|reset|suspend|destroy]'

command :power do |c|
  c.action do |global_options,options,args|
    vm_target = ARGV.shift
    desired_state = ARGV.shift
    @logger.debug "Power invoked for #{vm_target} with desired state #{desired_state}\n\t#{global_options}\n\t#{options}\n\t#{args}."

    vm_manager = Mesh::VSphere.new global_options
    vm = vm_manager.get_machine(vm_target, global_options[:datacenter])
    Mesh::logger.debug "Got vm #{vm.name}"

    case desired_state
    when 'on'
      vm.vm.PowerOnVM_Task.wait_for_completion
    when 'off'
      vm.vm.PowerOffVM_Task.wait_for_completion
    when 'reset'
      vm.vm.ResetVM_Task.wait_for_completion
    when 'suspend'
      vm.vm.SuspendVM_Task.wait_for_completion
    when 'destroy'
      vm.vm.Destroy_Task.wait_for_completion
    else
      abort "invalid command"
    end
  end
end
