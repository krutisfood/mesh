require 'test_helper'

class CreateTest < Test::Unit::TestCase

  def setup
    Mesh::logger = Logger.new(RUBY_PLATFORM =~ /mswin|mingw/ ? 'NUL:' : '/dev/null', 7)
  end

  def teardown
  end

  def test_create_with_unknown_template
    assert true
  end
end

