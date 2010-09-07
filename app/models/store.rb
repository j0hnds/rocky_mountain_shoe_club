class Store < ActiveRecord::Base
  include ValidationConstants

  validates_presence_of :name, :address_1, :city, :state, :postal_code
  validates_format_of :postal_code, :with => POSTAL_CODE_REGEX, :allow_blank => true
  validates_format_of :phone, :with => PHONE_REGEX, :allow_blank => true
  validates_format_of :fax, :with => PHONE_REGEX, :allow_blank => true
  validates_format_of :email, :with => EMAIL_REGEX, :allow_blank => true
  validates_length_of :name, :maximum => 40, :allow_blank => true
  validates_length_of :address_1, :maximum => 40, :allow_blank => true
  validates_length_of :address_2, :maximum => 40, :allow_blank => true
  validates_length_of :city, :maximum => 40, :allow_blank => true
  validates_length_of :state, :maximum => 2, :allow_blank => true
  validates_length_of :postal_code, :maximum => 11, :allow_blank => true
  validates_length_of :phone, :maximum => 12, :allow_blank => true
  validates_length_of :fax, :maximum => 12, :allow_blank => true
  validates_length_of :email, :maximum => 255, :allow_blank => true
end
