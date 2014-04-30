require 'test_helper'
require 'mocha/test_unit'

include RbVmomi
include Mesh

class MachineTest < Test::Unit::TestCase

  def setup
    Mesh::logger = Logger.new(RUBY_PLATFORM =~ /mswin|mingw/ ? 'NUL:' : '/dev/null', 7)
  end

  def teardown
  end

  def test_get_machine_uses_vim_connection
    connection_options = Hash.new
    VIM.stubs(:connect).returns("a string")
    vsphere_vm_manager = VSphere.new(connection_options)
    Machine.expects(:get).returns("fake vm")
    mock_vm = Object.new
    Machine.stubs( :get ).returns(mock_vm)
           #returns( stub(:cool? => true) ) # returns an object with just a .cool? method which in turn returns true

    vm = vsphere_vm_manager.get_machine("fake_machine","fake datacenter")
    
    assert vm == mock_vm
  end

  def test_clone_machine_uses_custom_spec
    #def clone_to (vm_name, vm_folder = '/', datastore = nil, custom_spec = nil, pool = nil)
    vm_template = Object.new
    fake_task = Object.new
    fake_task.expects(:wait_for_completion)
    vm_template.expects(:CloneVM_Task).returns(fake_task)
    template = Machine.new(vm_template)
    mock_custom_spec = Object.new
    mock_custom_spec.stubs(:spec)
    VIM.should_receive(:VirtualMachineRelocateSpec).with(:datastore    => nil,
                                                         :diskMoveType => :moveChildMostDiskBacking,
                                                         :pool         => nil) #.and_return(something)
                                                         
=begin
    mock_relocate_spec = VIM.stubs(:VirtualMachineRelocateSpec)
                            .expects(:datastore    => nil,
                                     :diskMoveType => :moveChildMostDiskBacking,
                                     :pool         => nil)
=end
    mock_clone_spec = Object.new
    mock_clone_spec.expects(:customization=)
    # This doesn't expect anything?
    VIM.stubs(:VirtualMachineCloneSpec).returns(mock_clone_spec)
         .expects(:location => mock_relocate_spec,
                  :powerOn  => false, 
                  :template => false)

    template.clone_to 'frank', '/', nil, mock_custom_spec
  end
end
