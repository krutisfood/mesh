require 'rbvmomi'
require 'logger'

# VM Manager Class to hand all things VSphere
module Mesh
  class VSphere
    attr_accessor :vim, :options
    def initialize(connection_options)
      Mesh::logger.debug "Opening connection to #{connection_options['host']}"
      @vim = RbVmomi::VIM.connect connection_options
      @options = connection_options
    end

    # Can we search through the datacenters for a machine?
    # Should we get the machine from the datacenters?
    def get_machine(machine_name, datacenter)
      Machine::get(self, datacenter, machine_name)
    end

    def clone_machine(vm_type, vm_target, default_vm_folder, machine_options)
      Mesh::template.has_key? vm_type.to_sym or raise "unknown machine type #{vm_type}, known types are #{Mesh::template.keys.to_s}"
      template = Mesh::template[vm_type.to_sym]
      vm_dest = VSphere.parse_vm_target vm_target, default_vm_folder
      vm_template = get_machine(template[:name], options[:datacenter])
      # Refactor & pass in options with the get or alternatively add a get and set method
      spec = get_custom_spec(template[:spec])
      spec.destination_ip_address = machine_options[:ip_address] if machine_options[:ip_address]
      pool = get_resource_pool(options[:resource_pool], options[:datacenter])
      datacenter = get_datacenter(options[:datacenter])
      datastore = get_datastore(machine_options[:datastore], datacenter)
      raise "No datastore found matching #{machine_options[:datastore]}. Exiting." if datastore.nil?
      Mesh::logger.debug "Got datastore named #{datastore.name} with free space #{datastore.free_space}."
      Mesh::logger.debug "Creating vm in folder #{vm_dest[:folder]} with name #{vm_dest[:name]}."
      folder = get_folder(vm_dest[:folder], options[:datacenter])
      Mesh::logger.debug "Using folder #{folder.to_s}."
      vm_template.clone_to(vm_dest[:name], folder, datastore, spec, pool)
    end

    def get_custom_spec(name)
      spec_mgr = @vim.serviceContent.customizationSpecManager
      CustomSpec::get(spec_mgr, name)
    end

    def get_resource_pool(name, datacenter_name)
      # KRUT this should be a ResourcePool wrapper object instead?
      Mesh::logger.debug "Chasing resource pool #{name}"
      Datacenter::find_pool(@vim, name, datacenter_name)
    end

    def get_datastore(name, datacenter)
      Mesh::logger.debug "Getting datastore #{name}"
      Datastore::get(@vim, name, datacenter)
    end

    def get_datacenter(name)
      Mesh::Datacenter::get(@vim, name)
    end

    def root_folder
      @vim.serviceInstance.content.rootFolder
    end

    def vm_root_folder
      @vim.serviceInstance.content.rootFolder.traverse(options[:datacenter]).vmFolder
    end

    def get_folder(path, datacenter_name)
      Mesh::logger.debug "Looking for folder #{path}."
      path.to_s == '/' ? vm_root_folder : vm_root_folder.traverse(path)
    end

    private
      def self.parse_vm_target(vm_target, default_vm_path = '/')
        vm_details = vm_target.match(/(.+)\/(.+)/)
        vm = Hash.new
        vm[:folder] = default_vm_path
        vm[:name]   = vm_target
        if vm_details
          vm[:folder] = vm_details[1]
          vm[:name]   = vm_details[2]
        end
        vm
      end
  end
end
