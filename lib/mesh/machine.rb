require 'rbvmomi'
require 'logger'

module Mesh
  class Machine
    attr_accessor :name, :vm
    def initialize(vm)
      Mesh::logger.debug "Creating new one of me with #{vm}"
      @vm = vm    #root_folder.traverse @name, RbVmomi::VIM::VirtualMachine
    end

    def self.Get(vim, datacentre, name)
      Mesh::logger.debug "Looking for vm #{name} at dc #{datacentre}."
      root_folder = vim.serviceInstance.content.rootFolder
      Mesh::logger.debug "Not sure you found the root folder champ." unless root_folder
      template_vm = root_folder.traverse(datacentre).vmFolder.traverse(name)
      template_vm or raise "unable to find template #{name} at #{datacentre}"
      Machine.new(template_vm)
    end

    def power_on
      raise NotImplementedError 
    end

    def command
      raise NotImplementedError
    end

    def describe
      raise NotImplementedError
    end

    def template?
      raise NotImplementedError
    end

    def ipAddress
      @vm.guest.ipAddress
    end

    def clone (vm_target, custom_spec = nil, pool = nil)
      Mesh::logger.info "Cloning #{@name} to a new vm named #{vm_target}."
      relocateSpec = RbVmomi::VIM.VirtualMachineRelocateSpec(:diskMoveType => :moveChildMostDiskBacking,
        :pool => pool)

      spec = RbVmomi::VIM.VirtualMachineCloneSpec(:location => relocateSpec,
                                         :powerOn  => false,
                                         :template => false)
      spec.customization = custom_spec.spec if custom_spec
      #spec.customization.nicSettingMap.first.adapter.ip = '10.10.101.82'

      Machine.new(@vm.CloneVM_Task(:folder => @vm.parent, :name => vm_target, :spec => spec).wait_for_completion)
    end
  end
end
