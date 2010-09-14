class ExhibitorRegistration < ActiveRecord::Base

  belongs_to :exhibitor
  belongs_to :show
  has_many :exhibitor_lines
  has_many :exhibitor_associates

  validates_presence_of :exhibitor_id, :show_id
  validates_length_of :room, :maximum => 10, :allow_blank => true
  
end
