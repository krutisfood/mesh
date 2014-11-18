require 'rbvmomi'

module Vmesh
  class Datastore
    attr_accessor :ds
    def initialize(ds)
      @ds = ds
    end

    def self.get(vim, name, datacenter)
      Vmesh::logger.debug "Getting a single datastore named #{name} at datacenter #{datacenter.name}."
      get_all_matching(vim,name,datacenter).sort_by{ |ds| ds.free_space }.reverse.first
    end

    def self.get_all_matching(vim, name, datacenter)
      Vmesh::logger.debug "Getting datastore matching name #{name} at datacenter #{datacenter.name}."
      stores = self.get_all(vim, datacenter).select{ |ds| ds.name == name }
      if stores.nil? or stores.empty?
        Vmesh::logger.info "No exact match found, searching for partial match"
        stores = self.get_all(vim, datacenter).select{ |ds| ds.name.include? name }
        Vmesh::logger.debug "Found #{stores.count} datastores."
        Vmesh::logger.debug "#{stores.map{|ds| "Name #{ds.name}, free space #{ds.free_space}"}}"
      end
      stores
    end


    def self.get_all(vim, datacenter)
      Vmesh::logger.debug "get_all datastores at #{datacenter.name}."
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
