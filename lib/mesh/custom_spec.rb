require 'rbvmomi'

module Mesh
  class CustomSpec
    attr_accessor :ip_address, :spec
    def initialize(spec)
      @spec = spec
    end

    def self.Get(custom_spec_manager, name)
      Mesh::logger.debug "Looking for spec #{name}"
      CustomSpec.new(custom_spec_manager.GetCustomizationSpec(:name => name).spec) or raise "Didn't find the custom spec!"
    end

    def destination_ip_address=(ip)
      Mesh::logger.debug "Setting spec ip address to #{ip}"
      @spec.nicSettingMap.first.adapter.ip = RbVmomi::VIM::CustomizationFixedIp("ipAddress" => ip) if ip
    end

    def destination_ip_address
      @spec.nicSettingMap.first.adapter.ip
    end
  end
end
