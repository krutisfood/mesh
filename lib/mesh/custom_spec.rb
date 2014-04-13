module Mesh
  class CustomSpec
    attr_accessor :ip_address, :spec
    def initialize(spec)
      @spec = spec
    end

    def self.Get(custom_spec_manager, name)
      Mesh::logger.debug "Looking for spec #{name}"
      # Probably could just do a line like this...
      # custom_spec_manager.info.where { |c| c.name == name }
      CustomSpec.new custom_spec_manager.GetCustomizationSpec(:name => name).spec
=begin
      custom_spec_manager.info.each do |c| 
        puts "#{ui.color("Customization Name", :cyan)}: #{c.name}"
        @spec = c
        return c if c.name == name
      end
=end
    end

    def destination_ip_address=(ip)
      Mesh::logger.debug "Setting spec ip address to #{ip}"
      #@logger.debug "Setting spec ip address to #{ip}"
      #@spec.nicSettingMap.first.adapter.ip.ipAddress = ip
      Mesh::logger.debug "Ip adapter... #{@spec.nicSettingMap.first.adapter.ip.inspect}"
      @spec.nicSettingMap.first.adapter.ip = ip
    end

    def destination_ip_address
      @spec.nicSettingMap.first.adapter.ip
    end
  end
end
