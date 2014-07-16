command [:list,:ls,:dir] do |c|
  c.desc 'list directory entries instead of contents, and do not dereference symbolic links'
  c.switch [:d, :directory]

  c.action do |global_options,options,args|
    vm_manager = Mesh::VSphere.new global_options
    show_vms = !options[:directory]
    folder = vm_manager.vm_root_folder
    Mesh::list_all_vms_under(folder, show_vms)
  end
end

module Mesh
  def self.list_all_vms_under(folder, show_vms, currently_in = '') # recursively go thru a folder, dumping vm info
     folder.childEntity.each do |x|
        name = x.to_s.split('(').first
        case name
        when "Folder"
          list_all_vms_under(x, show_vms, "#{currently_in}/#{x.name}" )
          puts "#{currently_in}/#{x.name}/" unless show_vms
        when "VirtualMachine"
          puts "#{currently_in}/#{x.name}" if show_vms
        else
           puts "# Unrecognized Entity " + x.to_s
        end
     end
  end
end
