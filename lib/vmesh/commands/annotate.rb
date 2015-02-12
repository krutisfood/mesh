
desc 'get or set annotations for the vm'
arg_name 'vm_name get|set "vm notes go here"'

command [:annotate,:note] do |c|
  c.action do |global_options,options,args|
    ARGV.size >= 2 or abort "must specify VM and an action"
    vm_target = ARGV.shift
    action = ARGV.shift
    @logger.debug "Annotate invoked for #{vm_target} with action #{action}\n\t#{global_options[:host]}\n\t#{options}\n\t#{args}."

    vm_manager = Vmesh::VSphere.new global_options
    vm = vm_manager.get_machine(vm_target, global_options[:datacenter])
    Vmesh::logger.debug "Got vm #{vm.name}"

    case action
      when 'get'
        puts vm.annotation
      when 'set'
        note = ARGV.shift or abort "No annotation given"
        vm.annotation = note
      else
        abort "Invalid action #{action}, valid ones are get|set." unless %w(get set).include? action
    end
  end
end
