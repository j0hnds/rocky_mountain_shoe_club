class ExhibitorLine < ActiveRecord::Base
  belongs_to :exhibitor_registration
  
  validates_presence_of :exhibitor_registration_id, :line, :priority
  validates_length_of :line, :maximum => 40, :allow_blank => true
end
