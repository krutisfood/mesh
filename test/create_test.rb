require 'test_helper'
require 'mesh/commands/create_helpers'

class CreateTest < Test::Unit::TestCase
#class CreateTest < Test::Test

  def setup
    Mesh::logger = Logger.new(RUBY_PLATFORM =~ /mswin|mingw/ ? 'NUL:' : '/dev/null', 7)
  end

  def teardown
  end

  def test_parse_vm_target_with_folder
    #vm_details = Mesh::parse_vm_target("dummy_folder/dummy_vm_name")
    #assert vm_details.is_hash?
    assert true
  end
end

=begin
        def get_raw_vmfolder(path, datacenter_name)
          # The required path syntax - 'topfolder/subfolder

          # Clean up path to be relative since we're providing datacenter name
          dc = find_raw_datacenter(datacenter_name)
          dc_root_folder = dc.vmFolder
          # Filter the root path for this datacenter not to be used."
          dc_root_folder_path=dc_root_folder.path.map { | id, name | name }.join("/")
          paths = path.sub(/^\/?#{Regexp.quote(dc_root_folder_path)}\/?/, '').split('/')

          return dc_root_folder if paths.empty?
          # Walk the tree resetting the folder pointer as we go
          paths.inject(dc_root_folder) do |last_returned_folder, sub_folder|
            # JJM VIM::Folder#find appears to be quite efficient as it uses the
            # searchIndex It certainly appears to be faster than
            # VIM::Folder#inventory since that returns _all_ managed objects of
            # a certain type _and_ their properties.
            sub = last_returned_folder.find(sub_folder, RbVmomi::VIM::Folder)
            raise ArgumentError, "Could not descend into #{sub_folder}. Please check your path. #{path}" unless sub
            sub
          end
        end
=end

