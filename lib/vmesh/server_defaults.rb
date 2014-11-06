module Vmesh
  @template = {
    :windows_dmz => {
      :name => 'Templates/W2012_DC',
      :spec => 'Windows2012R2_DC_DMZ'
    },
    :windows => {
      :name => 'Templates/W2012R2',
      :spec => 'Win2012R2_DC_Frontend'
      #:name => 'Templates/W2012R2_DC',
    },
    :linux => {
      :name => 'Templates/CENTOS_6',
      :spec => 'Linux No Prompt'
    },
    :suse => {
      :name => 'Templates/SLES11-2-WHICS',
      :spec => 'Linux No Prompt'
    }
  }

  def self.template
    @template
  end
end
