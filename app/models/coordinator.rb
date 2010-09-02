require 'lib/validation_constants'
class Coordinator < ActiveRecord::Base
  has_many :shows

  validates_presence_of :first_name, :last_name, :email, :phone
  validates_format_of :phone, :with => PHONE_REGEX, :allow_blank => true
  validates_format_of :email, :with => EMAIL_REGEX, :allow_blank => true
  validates_length_of :first_name, :maximum => 40, :allow_blank => true
  validates_length_of :last_name, :maximum => 40, :allow_blank => true
  validates_length_of :email, :maximum => 255, :allow_blank => true
  validates_length_of :phone, :maximum => 12, :allow_blank => true
end
