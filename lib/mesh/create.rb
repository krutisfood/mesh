module Mesh
  def create(vim, datacentre, template_name, new_machine_name, ip_address)
    # vm Get
    template = Mesh::Machine::Get vim, datacentre, template_name
    # get spec, I think this is right?
    spec = Mesh::CustomSpec::Get vim.serviceContent.customizationSpecManager
    spec.destination_ip_address ip_address
    # vm clone 
    vm.clone new_machine_name, spec
  end
end
