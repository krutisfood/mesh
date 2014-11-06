module Vmesh
  class Datacenter
    attr_accessor :dc
    def initialize(datacenter) 
      @dc = datacenter
    end

    def self.get(vim, datacenter_name)
      dc = vim.serviceInstance.find_datacenter(datacenter_name) or abort "datacenter #{datacenter_name} not found"
      Datacenter.new dc
    end

    # non wrapped object, gasp!
    def self.find_pool(vim, name, dcname = nil)
      Vmesh::logger.debug "Looking for datacenter pool #{name} in datacenter named #{dcname}."
      dc = vim.serviceInstance.find_datacenter(dcname) or abort "datacenter not found"
      dc = Datacenter.get(vim, nil).dc
      baseEntity = dc.hostFolder
      entityArray = name.split('/')
      entityArray.each do |entityArrItem|
        if entityArrItem != ''
          if baseEntity.is_a? RbVmomi::VIM::Folder
            baseEntity = baseEntity.childEntity.find { |f| f.name == entityArrItem } or abort "no such pool #{name} while looking for #{entityArrItem}"
          elsif baseEntity.is_a? RbVmomi::VIM::ClusterComputeResource
            baseEntity = baseEntity.resourcePool.resourcePool.find { |f| f.name == entityArrItem } or abort "no such pool #{name} while looking for #{entityArrItem}"
          elsif baseEntity.is_a? RbVmomi::VIM::ResourcePool
            baseEntity = baseEntity.resourcePool.find { |f| f.name == entityArrItem } or abort "no such pool #{name} while looking for #{entityArrItem}"
          else
            abort "Unexpected Object type encountered #{baseEntity.type} while finding resourcePool"
          end
        end
      end

      baseEntity = baseEntity.resourcePool if not baseEntity.is_a?(RbVmomi::VIM::ResourcePool) and baseEntity.respond_to?(:resourcePool)
      baseEntity
    end

    def name
      @dc.name
    end
  end
end
