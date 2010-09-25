class Exhibitor < ActiveRecord::Base
  include ValidationConstants

  cattr_reader :per_page
  @@per_page = 20

  has_many :exhibitor_registrations
  has_many :shows, :through => :exhibitor_registrations

  validates_presence_of :first_name, :last_name, :address_1, :city, :state, :postal_code
  validates_format_of :postal_code, :with => POSTAL_CODE_REGEX, :allow_blank => true
  validates_format_of :email, :with => EMAIL_REGEX, :allow_blank => true
  validates_format_of :phone, :with => PHONE_REGEX, :allow_blank => true
  validates_format_of :fax, :with => PHONE_REGEX, :allow_blank => true
  validates_format_of :cell, :with => PHONE_REGEX, :allow_blank => true
  validates_length_of :first_name, :maximum => 40, :allow_blank => true
  validates_length_of :last_name, :maximum => 40, :allow_blank => true
  validates_length_of :address_1, :maximum => 40, :allow_blank => true
  validates_length_of :address_2, :maximum => 40, :allow_blank => true
  validates_length_of :city, :maximum => 40, :allow_blank => true
  validates_length_of :state, :maximum => 2, :allow_blank => true
  validates_length_of :postal_code, :maximum => 11, :allow_blank => true
  validates_length_of :email, :maximum => 255, :allow_blank => true
  validates_length_of :phone, :maximum => 12, :allow_blank => true
  validates_length_of :fax, :maximum => 12, :allow_blank => true
  validates_length_of :cell, :maximum => 12, :allow_blank => true

  named_scope :search_for, lambda { | search_term | { :conditions => [ "UPPER(first_name) like ? OR UPPER(last_name) like ?", "#{search_term}%", "#{search_term}%" ] } unless search_term.blank? }
  named_scope :ordered, :order => "last_name ASC, first_name ASC"
end
