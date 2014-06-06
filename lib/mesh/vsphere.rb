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
  end
end
