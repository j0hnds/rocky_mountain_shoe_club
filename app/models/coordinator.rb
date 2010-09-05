require 'lib/validation_constants'
class Coordinator < ActiveRecord::Base
  include ValidationConstants
  has_many :shows

  validates_presence_of :first_name, :last_name, :email, :phone
  validates_format_of :phone, :with => PHONE_REGEX, :allow_blank => true
  validates_format_of :email, :with => EMAIL_REGEX, :allow_blank => true
  validates_length_of :first_name, :maximum => 40, :allow_blank => true
  validates_length_of :last_name, :maximum => 40, :allow_blank => true
  validates_length_of :email, :maximum => 255, :allow_blank => true
  validates_length_of :phone, :maximum => 12, :allow_blank => true

  named_scope :search_for, lambda { | search_term | { :conditions => [ "UPPER(first_name) like ? OR UPPER(last_name) like ?", "#{search_term}%", "#{search_term}%" ] } unless search_term.blank? }
  named_scope :ordered, :order => "last_name ASC, first_name ASC"

end
