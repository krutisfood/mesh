require 'test_helper'
require 'mocha/test_unit'

include RbVmomi
include Vmesh

class VSphereTest < Test::Unit::TestCase

  def setup
    @mock_vim = Object.new
    VIM.stubs(:connect).returns(@mock_vim)
    @mock_connection_options = Hash.new
    Vmesh::logger = Logger.new(RUBY_PLATFORM =~ /mswin|mingw/ ? 'NUL:' : '/dev/null', 7)
  end

  def teardown
  end

  def test_get_machine_uses_vim_connection
    vsphere_vm_manager = VSphere.new(@mock_connection_options)
    #Machine.expects(:get).returns('fake vm')
    mock_vm = Object.new
    Machine.stubs( :get ).returns(mock_vm)
           #returns( stub(:cool? => true) ) # returns an object with just a .cool? method which in turn returns true

    vm = vsphere_vm_manager.get_machine('fake_machine','fake datacenter')
    
    assert vm == mock_vm
  end

  def test_root_folder_gets_from_vim
    vsphere_vm_manager = VSphere.new(@mock_connection_options)
    mock_root_folder = Object.new
    mock_content = Object.new
    mock_content.expects(:rootFolder).returns(mock_root_folder)
    mock_service_instance = Object.new
    mock_service_instance.expects(:content).returns(mock_content)
    @mock_vim.expects(:serviceInstance).returns(mock_service_instance) #Object.new.expects(:content).expects(:rootFolder).returns('a folder'))

    root_folder = vsphere_vm_manager.root_folder 

    assert root_folder == mock_root_folder
  end
end
