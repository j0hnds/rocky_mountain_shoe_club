class ExhibitorAssociate < ActiveRecord::Base
  belongs_to :exhibitor_registration
  has_many :associate_lines

  validates_presence_of :exhibitor_registration_id, :first_name, :last_name
  validates_length_of :first_name, :maximum => 40, :allow_blank => true
  validates_length_of :last_name, :maximum => 40, :allow_blank => true
  validates_length_of :room, :maximum => 10, :allow_blank => true
end
