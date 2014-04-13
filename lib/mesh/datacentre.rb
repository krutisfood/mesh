module Mesh
  class Datacentre
    def initialize() # things I may need... (vim,datacenter,insecure,host,resource_pool)
    end

    def self.find_pool(vim,poolName)
      dcname = nil
      Mesh::logger.debug "Looking for datacenter pool #{poolName}"
      dc = vim.serviceInstance.find_datacenter(dcname) or abort "datacenter not found"
      baseEntity = dc.hostFolder
      entityArray = poolName.split('/')
      entityArray.each do |entityArrItem|
        if entityArrItem != ''
          if baseEntity.is_a? RbVmomi::VIM::Folder
            baseEntity = baseEntity.childEntity.find { |f| f.name == entityArrItem } or abort "no such pool #{poolName} while looking for #{entityArrItem}"
          elsif baseEntity.is_a? RbVmomi::VIM::ClusterComputeResource
            baseEntity = baseEntity.resourcePool.resourcePool.find { |f| f.name == entityArrItem } or abort "no such pool #{poolName} while looking for #{entityArrItem}"
          elsif baseEntity.is_a? RbVmomi::VIM::ResourcePool
            baseEntity = baseEntity.resourcePool.find { |f| f.name == entityArrItem } or abort "no such pool #{poolName} while looking for #{entityArrItem}"
          else
            abort "Unexpected Object type encountered #{baseEntity.type} while finding resourcePool"
          end
        end
      end

      baseEntity = baseEntity.resourcePool if not baseEntity.is_a?(RbVmomi::VIM::ResourcePool) and baseEntity.respond_to?(:resourcePool)
      baseEntity
    end
  end
end
