require 'test_helper'

include RbVmomi
include Vmesh

class DatastoreTest < Test::Unit::TestCase

  def setup
    Vmesh::logger = Logger.new(RUBY_PLATFORM =~ /mswin|mingw/ ? 'NUL:' : '/dev/null', 7)
  end

  def teardown
  end

  def test_gets_exact_match_not_partial
    fake_ds1,matching_fake,fake_ds2 = mock,mock,mock
    vim,dc = mock,mock
    fake_ds1.stubs(:name => "GRAIN_STORE", :free_space => 100)
    matching_fake = stub(:name => "GRAIN_STORE_1", :free_space => 200)
    fake_ds2.stubs(:name => "BRAIN_STORE", :free_space => 200)
    stores = [fake_ds1, matching_fake, fake_ds2]
    dc.stubs(:name => 'fake_dc')
    Vmesh::Datastore.stubs(:get_all => stores)

    store = Vmesh::Datastore.get vim,'GRAIN_STORE_1',dc

    assert_equal matching_fake,store
  end

  def test_gets_partial_with_most_space_when_no_exact_match
    fake_ds1,matching_fake,fake_ds2 = mock,mock,mock
    vim,dc = mock,mock
    fake_ds1.stubs(:name => "GRAIN_STORE", :free_space => 100)
    matching_fake = stub(:name => "GRAIN_STORE_1", :free_space => 200)
    fake_ds2.stubs(:name => "BRAIN_STORE", :free_space => 20)
    stores = [fake_ds1, matching_fake, fake_ds2]
    dc.stubs(:name => 'fake_dc')
    Vmesh::Datastore.stubs(:get_all => stores)

    store = Vmesh::Datastore.get vim,'RAIN_STORE',dc
    
    assert_equal matching_fake,store
  end
end
