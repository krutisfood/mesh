require 'vmesh/version.rb'

# Add requires for other files you add to your project here, so
# you just need to require this one file in your bin file

require 'vmesh/server_defaults.rb'
require 'vmesh/machine.rb'
require 'vmesh/logger.rb'
require 'vmesh/create.rb'
require 'vmesh/list.rb'
require 'vmesh/custom_spec.rb'
require 'vmesh/datacenter.rb'
require 'vmesh/vsphere.rb'
require 'vmesh/datastore.rb'

module Vmesh
  def self.logger
    @logger ||= Logger.new STDOUT
  end
end
