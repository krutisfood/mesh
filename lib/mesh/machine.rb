module Mesh
  class Machine
    def self.power_on
      raise NotImplementedError 
    end

    def self.command
      raise NotImplementedError
    end

    def self.describe
      raise NotImplementedError
    end

    def self.template?
      raise NotImplementedError
    end

    def self.clone (name)
      raise NotImplementedError
    end
  end
end
