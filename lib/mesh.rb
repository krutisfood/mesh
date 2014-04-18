require 'mesh/version.rb'

# Add requires for other files you add to your project here, so
# you just need to require this one file in your bin file

require 'mesh/server_defaults.rb'
require 'mesh/machine.rb'
require 'mesh/logger.rb'
require 'mesh/create.rb'
require 'mesh/list.rb'
require 'mesh/custom_spec.rb'
require 'mesh/datacenter.rb'
require 'mesh/vsphere.rb'
require 'mesh/datastore.rb'

module Mesh
  def self.logger
    @logger ||= Logger.new STDOUT
  end
end
