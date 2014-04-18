require 'rbvmomi'

module Mesh
  class Datastore
    attr_accessor :ds
    def initialize(ds)
      @ds = ds
    end

    def self.get(vim, name, datacenter)
      Mesh::logger.debug "Getting datastore named #{name} at datacenter #{datacenter.inspect}." 
      dc = vim.serviceContent.viewManager.CreateContainerView({
        :container  => datacenter.dc.datastoreFolder,
        :type       => ["Datastore"],
        :recursive  => true
      }).view.select{|ds| ds.name == name}.first
      if dc.nil?
        Mesh::logger.info("Unable to find exact match for datastore, looking for store including string #{name}.")
        dc = vim.serviceContent.viewManager.CreateContainerView({
          :container  => datacenter.dc.datastoreFolder,
          :type       => ["Datastore"],
          :recursive  => true
        }).view.select{|ds| ds.name.include? name}.sort_by{ |ds| ds.summary.capacity - ds.summary.freeSpace }.first
      end
      Mesh::logger.debug "May have found #{dc}"
      dc
    end
  end
end
