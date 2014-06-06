require 'rbvmomi'

module Mesh
  class Datastore
    attr_accessor :ds
    def initialize(ds)
      @ds = ds
    end

    def self.get(vim, name, datacenter)
      Mesh::logger.debug "Getting datastore named #{name} at datacenter #{datacenter.name}." 
      stores = self.get_all(vim, datacenter).select{ |ds| ds.name == name }
      if stores.nil? or stores.empty?
        Mesh::logger.info "No exact match found, searching for partial match"
        stores = self.get_all(vim, datacenter).select{ |ds| ds.name.include? name }
        Mesh::logger.debug "Found #{stores.count} datastores."
        Mesh::logger.debug "#{stores.map{|ds| "Name #{ds.name}, free space #{ds.free_space}"}}"
      end
      stores.sort_by{ |ds| ds.free_space }.reverse.first
    end

    def self.get_all(vim, datacenter)
      Mesh::logger.debug "get_all datastores at #{datacenter.name}."
      vim.serviceContent.viewManager.CreateContainerView({
        :container  => datacenter.dc.datastoreFolder,
        :type       => ["Datastore"],
        :recursive  => true
      }).view.map{ |ds| Datastore.new(ds) } #.select{|ds| ds.name == name}.first
    end

    def name
      @ds.name
    end

    def free_space
      @ds.summary.freeSpace
    end

    def capacity
      @ds.summary.capacity
    end

    def to_s
      "name: #{name}, free_space: #{free_space}, capacity: #{capacity}"
    end
  end
end
