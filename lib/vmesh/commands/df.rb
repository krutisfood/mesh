
desc 'report datastore space usage'
arg_name '[name]'

command [:df,:diskspace] do |c|

  c.action do |global_options,options,args|
    name = ARGV.shift if ARGV.any?
    vm_manager = Vmesh::VSphere.new global_options
    if name.to_s == ''
      all_datastores = Vmesh::Datastore.get_all(vm_manager.vim, vm_manager.get_datacenter(global_options[:datacenter]))
    else
      all_datastores = Vmesh::Datastore.get_all_matching(vm_manager.vim, name, vm_manager.get_datacenter(global_options[:datacenter]))
    end
    puts '%-30.30s%15.15s%15.15s%15.15s%8.8s' %  ["Name","Size","Available","Used","Use%"]
    all_datastores.each do |ds|
      pc_free = (ds.free_space.to_i * 100) / ds.capacity.to_i
      puts '%-30.30s%15.15s%15.15s%15.15s%8.8s' % ["#{ds.name}","#{ds.capacity}","#{ds.free_space}","#{ds.capacity}","#{pc_free}%"]
    end
  end
end
