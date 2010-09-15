class AssociateLine < ActiveRecord::Base
  belongs_to :exhibitor_associate

  validates_presence_of :exhibitor_associate_id, :line, :priority
  validates_length_of :line, :maximum => 80, :allow_blank => true
end
