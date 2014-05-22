require 'test_helper'
#gem 'mocha'
#require 'mocha/test_unit'

include RbVmomi
include Mesh

class DatastoreTest < Test::Unit::TestCase

  def setup
    @mock_vim = Object.new
    VIM.stubs(:connect).returns(@mock_vim)
    @mock_connection_options = Hash.new
    Mesh::logger = Logger.new(RUBY_PLATFORM =~ /mswin|mingw/ ? 'NUL:' : '/dev/null', 7)
  end

  def teardown
  end

  def test_get_all
# KRUT Should these be stubs rather than expects? Supply a fake instead of assertion?
    mock_datastores = [ 'ds_a','ds_b','ds_c' ]
    mock_view_manager = Object.new
    mock_service_content = Object.new
    #mock_service_content.expects(:viewManager).returns(mock_view_manager)
    #@mock_vim.expects(:serviceContent).returns(mock_service_content)
=begin
      vim.serviceContent.viewManager.CreateContainerView({
        :container  => datacenter.dc.datastoreFolder,
        :type       => ["Datastore"],
        :recursive  => true
      }).view
=end
    vsphere_vm_manager = VSphere.new(@mock_connection_options)
    #Machine.expects(:get).returns('fake vm')
    mock_vm = Object.new
    Machine.stubs( :get ).returns(mock_vm)
           #returns( stub(:cool? => true) ) # returns an object with just a .cool? method which in turn returns true

    vm = vsphere_vm_manager.get_machine('fake_machine','fake datacenter')
    
    assert vm == mock_vm
  end

  def test_get_returns_first_match
    #assert false, "Not yet implemented"
  end

  def test_get_returns_first_including_name_if_no_exact_match
    #assert false, "Not yet implemented"
  end
end
