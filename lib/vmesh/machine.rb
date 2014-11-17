require 'rbvmomi'
require 'logger'

module Vmesh
  class Machine
    attr_accessor :name, :vm
    @@states = {'on' => 'PowerOnVM_Task', 'off' => 'PowerOffVM_Task', 'reset' => 'ResetVM_Task', 'suspend' => 'SuspendVM_Task', 'destroy' => 'Destroy_Task' }

    def initialize(vm)
      Vmesh::logger.debug "New machine wrapper object with #{vm}"
      @vm = vm
    end

    def self.get(vs_manager, datacenter_name, name)
      Vmesh::logger.debug "looking for vm #{name} at dc #{datacenter_name}."
      vm = vs_manager.vm_root_folder.traverse(name)
      vm or raise "unable to find machine #{name} at #{datacenter_name}"
      Machine.new vm 
    end

    def self.valid_states
      @@states.keys
    end

    def power(desired_state)
      p "Found" if @@states.has_key? desired_state
      p "NOT Found" unless @@states.has_key? desired_state
      raise ArgumentError, "Invalid desired power state" unless @@states.has_key? desired_state
      @vm.send(@@states[desired_state])
    end

    def revert
      @vm.RevertToCurrentSnapshot_Task.wait_for_completion
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

    def clone_to (vm_name, vm_folder = @vm.parent, datastore = nil, custom_spec = nil, pool = nil, config = {})
      Vmesh::logger.info "Cloning #{@name} to a new vm named #{vm_name} in folder #{vm_folder}."
      ds = datastore.ds unless datastore.nil?
      relocateSpec = RbVmomi::VIM.VirtualMachineRelocateSpec(:datastore    => ds,
                                                             :diskMoveType => :moveChildMostDiskBacking,
                                                             :pool         => pool)
      clone_spec = RbVmomi::VIM.VirtualMachineCloneSpec(:location => relocateSpec,
                                                        :powerOn  => false,
                                                        :template => false)
      clone_spec.customization = custom_spec.spec if custom_spec
      Vmesh::logger.debug "Custom spec #{custom_spec} supplied, config #{config.inspect}."

      Machine.new(@vm.CloneVM_Task(:folder => vm_folder, :name => vm_name, :spec => clone_spec, :numCPUs => config[:numCPUs], :memoryMB => config[:memoryMB]).wait_for_completion)
    end
  end
end
