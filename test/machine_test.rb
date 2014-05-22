require 'test_helper'

include RbVmomi
include Mesh

class MachineTest < Test::Unit::TestCase

  def setup
    Mesh::logger = Logger.new(RUBY_PLATFORM =~ /mswin|mingw/ ? 'NUL:' : '/dev/null', 7)
  end

  def teardown
  end

=begin
  def test_get_machine_uses_vim_connection
    connection_options = Hash.new
    VIM.stubs(:connect).returns("a string")
    vsphere_vm_manager = VSphere.new(connection_options)
    #Machine.expects(:get).returns("fake vm")
    mock_vm = Object.new
    Machine.stubs( :get ).returns(mock_vm)
           #returns( stub(:cool? => true) ) # returns an object with just a .cool? method which in turn returns true

    vm = vsphere_vm_manager.get_machine("fake_machine","fake datacenter")
    
    assert vm == mock_vm
  end
=end

  def test_clone_machine_uses_custom_spec
    #def clone_to (vm_name, vm_folder = '/', datastore = nil, custom_spec = nil, pool = nil)
    vm_template = Object.new
    fake_task = Object.new
    #fake_task.expects(:wait_for_completion)
    vm_template.expects(:CloneVM_Task).returns(fake_task)
    template = Machine.new(vm_template)
    mock_custom_spec = Object.new
    mock_custom_spec.stubs(:spec)
    mock_relocate_spec = VIM.stubs(:VirtualMachineRelocateSpec)
=begin
                            .expects(:datastore    => nil,
                                     :diskMoveType => :moveChildMostDiskBacking,
                                     :pool         => nil)

=end
    mock_clone_spec = Object.new
    mock_clone_spec.expects(:customization=)
    # This doesn't expect anything?
    VIM.stubs(:VirtualMachineCloneSpec).returns(mock_clone_spec)
=begin
    
         .expects(:location => mock_relocate_spec,
                  :powerOn  => false, 
                  :template => false)
=end

    template.clone_to 'frank', '/', nil, mock_custom_spec
  end

  def test_power_on_invokes_PowerOnVMTask
    fake_vs_vm = Object.new
    vm = Machine.new(fake_vs_vm)
    fake_vs_vm.expects(:PowerOnVM_Task)

    vm.power 'on'
  end

  def test_power_off_invokes_PowerOffVMTask
    fake_vs_vm = Object.new
    vm = Machine.new(fake_vs_vm)
    fake_vs_vm.expects(:PowerOffVM_Task)

    vm.power 'off'
  end

  def test_power_reset_invokes_PowerOnVMTask
    fake_vs_vm = Object.new
    vm = Machine.new(fake_vs_vm)
    fake_vs_vm.expects(:ResetVM_Task)

    vm.power 'reset'
  end

  def test_power_suspend_invokes_PowerOnVMTask
    fake_vs_vm = Object.new
    vm = Machine.new(fake_vs_vm)
    fake_vs_vm.expects(:SuspendVM_Task)

    vm.power 'suspend'
  end

  def test_power_destroy_invokes_PowerOnVMTask
    fake_vs_vm = Object.new
    vm = Machine.new(fake_vs_vm)
    fake_vs_vm.expects(:Destroy_Task)

    vm.power 'destroy'
  end

  def test_power_unknown_raises
    fake_vs_vm = Object.new
    vm = Machine.new(fake_vs_vm)
    #fake_vs_vm.expects(:PowerOnVM_Task)

    exception = assert_raise(ArgumentError) { vm.power "to the people" }
  end
end
