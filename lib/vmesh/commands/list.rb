
desc 'list directory contents'
arg_name '[dir]'

command [:list,:ls,:dir] do |c|
  c.desc 'list directory entries instead of contents, and do not dereference symbolic links'
  c.switch [:d, :directory]

  c.desc 'list recursively'
  c.switch [:r, :recursive]

  c.action do |global_options,options,args|
    pwd = ARGV.shift if ARGV.any?
    vm_manager = Vmesh::VSphere.new global_options
    show_directories_only = options[:directory]
    folder = pwd.nil? ? vm_manager.vm_root_folder : vm_manager.get_folder(pwd)
    raise "Folder #{pwd} not found, exiting" if folder.to_s == ''
    Vmesh::logger.debug "Searching folder #{folder.name}."
    Vmesh::list_under folder,show_directories_only,options[:recursive],"/#{folder.name}"
  end
end

module Vmesh
  def self.list_under(folder, show_directories_only, recurse = false, currently_in = '')
     currently_in = '' if currently_in == '/vm'
     folder.childEntity.each do |x|
        name = x.to_s.split('(').first
        case name
        when "Folder"
          puts "#{currently_in}/#{x.name}/" #if show_directories_only
          list_under(x, show_directories_only, recurse, "#{currently_in}/#{x.name}" ) if recurse
        when "VirtualMachine"
          puts "#{currently_in}/#{x.name}" unless show_directories_only
        else
           puts "# Unrecognized Entity " + x.to_s
        end
     end
  end
end
