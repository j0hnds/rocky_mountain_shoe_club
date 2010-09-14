class Buyer < ActiveRecord::Base
  include ValidationConstants

  belongs_to :store
  has_many :buyer_registrations
  has_many :shows, :through => :buyer_registrations

  validates_presence_of :store_id, :first_name, :last_name
  validates_format_of :phone, :with => PHONE_REGEX, :allow_blank => true
  validates_format_of :email, :with => EMAIL_REGEX, :allow_blank => true
  validates_length_of :first_name, :maximum => 40, :allow_blank => true
  validates_length_of :last_name, :maximum => 40, :allow_blank => true
  validates_length_of :phone, :maximum => 12, :allow_blank => true
  validates_length_of :email, :maximum => 255, :allow_blank => true

  named_scope :search_for, lambda { | search_term | { :conditions => [ "UPPER(first_name) like ? OR UPPER(last_name) like ?", "#{search_term}%", "#{search_term}%" ] } unless search_term.blank? }
  named_scope :ordered, :order => "last_name ASC, first_name ASC"

end
