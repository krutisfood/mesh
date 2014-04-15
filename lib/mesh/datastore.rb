require 'rbvmomi'

module Mesh
  class Datastore
    attr_accessor :ds
    def initialize(ds)
      @ds = ds
    end

    def self.get(vim, datastore_name, datacenter)
      Mesh::logger.debug "Getting datastore named #{datastore_name} at datacenter #{datacenter.inspect}." 
      #dc = Datacenter::get(vim, datacenter_name)
      #options['datastore'], options['datacenter'
# krut this vim was @connection, whatever that is/was
      dc = vim.serviceContent.viewManager.CreateContainerView({
        :container  => datacenter.dc.datastoreFolder,
        :type       => ["Datastore"],
        :recursive  => true
      }).view.select{|ds| ds.name == datastore_name}.first
      Mesh::logger.debug "May have found #{dc}"
      dc
    end
  end
end
