
class Show < ActiveRecord::Base
  include ShowDates
  belongs_to :coordinator
  belongs_to :venue
  has_many :exhibitor_registrations
  has_many :exhibitors, :through => :exhibitor_registrations

  validates_presence_of :description, :coordinator_id, :venue_id, :start_date, :end_date, :next_start_date, :next_end_date
  validates_length_of :description, :maximum => 40, :allow_blank => true

  named_scope :search_for, lambda { | search_term | { :conditions => [ "UPPER(description) like ?", "#{search_term}%" ] } unless search_term.blank? }
  named_scope :ordered, :order => "start_date ASC, description ASC"

  def set_default_dates(from_date=Date.today)
    self.start_date = next_show_date(from_date)
    self.end_date = self.start_date + 1.day

    self.next_start_date = next_show_date(self.end_date)
    self.next_end_date = self.next_start_date + 1.day
  end
end
