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
    vm_template, fake_task = mock, mock
    fake_task.expects(:wait_for_completion)
    vm_template.expects(:CloneVM_Task).returns(fake_task)
    template = Machine.new(vm_template)
    mock_custom_spec = mock
    mock_custom_spec.stubs(:spec)
    VIM.stubs(:VirtualMachineRelocateSpec)
    mock_clone_spec = mock
    mock_clone_spec.expects(:customization=)
    VIM.stubs(:VirtualMachineCloneSpec).returns(mock_clone_spec)

    template.clone_to 'frank', '/', nil, mock_custom_spec
  end

  def test_power_on_invokes_PowerOnVMTask
    fake_vs_vm = mock
    vm = Machine.new(fake_vs_vm)
    fake_vs_vm.expects(:PowerOnVM_Task)

    vm.power 'on'
  end

  def test_power_off_invokes_PowerOffVMTask
    fake_vs_vm = mock
    vm = Machine.new(fake_vs_vm)
    fake_vs_vm.expects(:PowerOffVM_Task)

    vm.power 'off'
  end

  def test_power_reset_invokes_PowerOnVMTask
    fake_vs_vm = mock
    vm = Machine.new(fake_vs_vm)
    fake_vs_vm.expects(:ResetVM_Task)

    vm.power 'reset'
  end

  def test_power_suspend_invokes_PowerOnVMTask
    fake_vs_vm = mock
    vm = Machine.new(fake_vs_vm)
    fake_vs_vm.expects(:SuspendVM_Task)

    vm.power 'suspend'
  end

  def test_power_destroy_invokes_PowerOnVMTask
    fake_vs_vm = mock
    vm = Machine.new(fake_vs_vm)
    fake_vs_vm.expects(:Destroy_Task)

    vm.power 'destroy'
  end

  def test_power_unknown_raises
    fake_vs_vm = mock
    vm = Machine.new(fake_vs_vm)
    #fake_vs_vm.expects(:PowerOnVM_Task)

    assert_raise(ArgumentError) { vm.power "to the people" }
  end
end
