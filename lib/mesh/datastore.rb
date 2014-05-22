require 'rbvmomi'

module Mesh
  class Datastore
    attr_accessor :ds
    def initialize(ds)
      @ds = ds
    end

    def self.get(vim, name, datacenter)
      Mesh::logger.debug "Getting datastore named #{name} at datacenter #{datacenter}." 
      ds = self.get_all(vim, datacenter).select{ |ds| ds.name == name }.first
      if ds.nil?
        Mesh::logger.info("Unable to find exact match for datastore, looking for store including string #{name}.")
        ds = self.get_all(vim, datacenter).select{ |ds| ds.name.include? name }.first
      end
      ds
=begin
      ds = vim.serviceContent.viewManager.CreateContainerView({
        :container  => datacenter.dc.datastoreFolder,
        :type       => ["Datastore"],
        :recursive  => true
      }).view.select{|ds| ds.name == name}.first
      if ds.nil?
        Mesh::logger.info("Unable to find exact match for datastore, looking for store including string #{name}.")
        ds = vim.serviceContent.viewManager.CreateContainerView({
          :container  => datacenter.dc.datastoreFolder,
          :type       => ["Datastore"],
          :recursive  => true
        }).view.select{|ds| ds.name.include? name}.sort_by{ |ds| ds.summary.capacity - ds.summary.freeSpace }.first
      end
=end
      Mesh::logger.debug "May have found #{ds.name}" unless ds.nil?
      Mesh::logger.warn "Didn't find datastore"
      ds
    end

    def self.get_all(vim, datacenter)
      vim.serviceContent.viewManager.CreateContainerView({
        :container  => datacenter.dc.datastoreFolder,
        :type       => ["Datastore"],
        :recursive  => true
      }).view.map{ |ds| Datastore.new(ds) } #.select{|ds| ds.name == name}.first
    end

    def name
      ds.name
    end
  end
end
