#arg_name '[dir]'

command [:list,:ls,:dir] do |c|
  c.desc 'list directory entries instead of contents, and do not dereference symbolic links'
  c.switch [:d, :directory]

  c.action do |global_options,options,args|
    
    vm_manager = Mesh::VSphere.new global_options

    show_vms = !options[:directory]
    
    folder = vm_manager.root_folder.traverse(global_options[:datacenter]).vmFolder
    Mesh::list_all_vms_under(folder, show_vms)
  end
end

module Mesh
  def self.list_all_vms_under(folder, show_vms, currently_in = '') # recursively go thru a folder, dumping vm info
     folder.childEntity.each do |x|
        name, junk = x.to_s.split('(')
        case name
        when "Folder"
          #Mesh::logger.info "#{currently_in}/#{x.name}:"
          list_all_vms_under(x, show_vms, "#{currently_in}/#{x.name}" )
          puts "#{currently_in}/#{x.name}/" unless show_vms
        when "VirtualMachine"
          puts "#{currently_in}/#{x.name}" if show_vms
        else
           puts "# Unrecognized Entity " + x.to_s
        end
     end
  end
=begin
   dcs = ['firstdc', 'seconddc', 'thirddc']
   dcs.each do |dc|
      vms(vim1.serviceInstance.find_datacenter(dc).vmFolder)
   end
=end
end
