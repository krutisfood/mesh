module Vmesh
  def create(vim, datacenter, template_name, new_machine_name, ip_address)
    # vm get
    template = Vmesh::Machine::get vim, datacenter, template_name
    # get spec, I think this is right?
    spec = Vmesh::CustomSpec::get vim.serviceContent.customizationSpecManager
    spec.destination_ip_address ip_address
    # vm clone 
    vm.clone new_machine_name, spec
  end
end
