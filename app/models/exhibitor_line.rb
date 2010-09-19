class ExhibitorLine < ActiveRecord::Base
  belongs_to :exhibitor_registration
  has_one :exhibitor, :through => :exhibitor_registration
  has_one :show, :through => :exhibitor_registration
  
  validates_presence_of :exhibitor_registration_id, :line, :priority
  validates_length_of :line, :maximum => 80, :allow_blank => true

  named_scope :ordered, :order => 'line ASC'
  named_scope :for_show, lambda { | show_id | { :joins => :exhibitor_registration, :conditions => [ 'show_id = ?', show_id ] } }
end
