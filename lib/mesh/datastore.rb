require 'rbvmomi'

module Mesh
  class Datastore
    attr_accessor :ds
    def initialize(ds)
      @ds = ds
    end

    def self.get(vim, name, datacenter)
      Mesh::logger.debug "Getting datastore named #{name} at datacenter #{datacenter}." 
      stores = self.get_all(vim, datacenter).select{ |ds| ds.name == name }
      if stores.nil? or stores.empty?
        stores = self.get_all(vim, datacenter).select{ |ds| ds.name.include? name }
      end
      stores.sort_by{ |ds| ds.free_space }.reverse.first
    end

    def self.get_all(vim, datacenter)
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
  end
end
