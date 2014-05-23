require 'test_helper'

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

  def test_get_gets_exact_match_not_partial
    fake_ds1,matching_fake,fake_ds2 = Object.new,Object.new,Object.new,Object.new,Object.new
    fake_ds1.stubs(:name).returns("GRAIN_STORE")
    fake_ds1.stubs(:free_space).returns(100)
    matching_fake.stubs(:name).returns "GRAIN_STORE_1"
    matching_fake.stubs(:free_space).returns(200)
    fake_ds2.stubs(:name).returns "BRAIN_STORE"
    fake_ds2.stubs(:free_space).returns(200)
    stores = [fake_ds1, matching_fake, fake_ds2]

    got_all = stub
    vim,dc = stub,stub
    Mesh::Datastore.stubs(:get_all).with(vim,dc).returns(stores)

    store = Mesh::Datastore.get vim,'GRAIN_STORE_1',dc
    
    assert_equal matching_fake,store
  end

  def test_get_returns_partial_with_most_space_when_no_exact_match
    fake_ds1,matching_fake,fake_ds2 = Object.new,Object.new,Object.new,Object.new,Object.new
    fake_ds1.stubs(:name).returns("GRAIN_STORE")
    fake_ds1.stubs(:free_space).returns(100)
    matching_fake.stubs(:name).returns "GRAIN_STORE_1"
    matching_fake.stubs(:free_space).returns(200)
    fake_ds2.stubs(:name).returns "BRAIN_STORE"
    fake_ds2.stubs(:free_space).returns(20)
    stores = [fake_ds1, fake_ds2, matching_fake]

    got_all = stub
    vim,dc = stub,stub
    Mesh::Datastore.stubs(:get_all).with(vim,dc).returns(stores)

    store = Mesh::Datastore.get vim,'RAIN_STORE',dc
    
    assert_equal matching_fake,store
  end
end
