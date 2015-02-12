
desc 'report datastore space usage'
arg_name '[name]'

command [:df,:diskspace] do |c|
  c.desc 'Display sizes in GB'
  c.long_desc 'Display disk usage and sizes in GB'
  c.switch [:g]

  c.desc 'Display sizes in MB'
  c.long_desc 'Display disk usage and sizes in MB'
  c.switch [:m]

  c.action do |global_options,options,args|
    name = ARGV.shift if ARGV.any?
    size_divisor = 1024
    size_heading = '1K-blocks'
    if options[:g]
      size_divisor = 1024 ** 3
      size_heading = '1G-blocks'
    elsif options[:m]
      size_divisor = 1024 ** 2
      size_heading = '1M-blocks'
    end
    vm_manager = Vmesh::VSphere.new global_options
    if name.to_s == ''
      all_datastores = Vmesh::Datastore.get_all(vm_manager.vim, vm_manager.get_datacenter(global_options[:datacenter]))
    else
      all_datastores = Vmesh::Datastore.get_all_matching(vm_manager.vim, name, vm_manager.get_datacenter(global_options[:datacenter]))
    end
    puts '%-30.30s%15.15s%15.15s%15.15s%8.8s' %  ["Name",size_heading,"Available","Used","Use%"]
    all_datastores.each do |ds|
      ds_used = ds.capacity - ds.free_space
      pc_used = (ds_used.to_i * 100) / ds.capacity.to_i
      puts '%-30.30s%15.15s%15.15s%15.15s%8.8s' % ["#{ds.name}","#{ds.capacity/size_divisor}","#{ds.free_space/size_divisor}","#{ds_used/size_divisor}","#{pc_used}%"]
    end
  end
end
