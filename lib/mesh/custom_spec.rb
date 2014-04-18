require 'rbvmomi'

module Mesh
  class CustomSpec
    attr_accessor :ip_address, :spec
    def initialize(spec)
      @spec = spec
    end

    def self.get(custom_spec_manager, name)
      Mesh::logger.debug "Looking for spec #{name}"
      spec = custom_spec_manager.GetCustomizationSpec(:name => name).spec or raise "unable to find the custom spec #{name}."
      CustomSpec.new(spec)
    end

    def destination_ip_address=(ip)
      Mesh::logger.debug "Setting spec ip address to #{ip}"
      @spec.nicSettingMap.first.adapter.ip = RbVmomi::VIM::CustomizationFixedIp("ipAddress" => ip)
    end

    def destination_ip_address
      @spec.nicSettingMap.first.adapter.ip
    end
  end
end
