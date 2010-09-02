class Show < ActiveRecord::Base
  belongs_to :coordinator
  belongs_to :venue

  validates_presence_of :description, :coordinator_id, :venue_id, :start_date, :end_date, :next_start_date, :next_end_date
  validates_length_of :description, :maximum => 40, :allow_blank => true

  def set_default_dates(from_date=Date.today)
    self.start_date = next_show_date(from_date)
    self.end_date = self.start_date + 1.day

    self.next_start_date = next_show_date(self.end_date)
    self.next_end_date = self.next_start_date + 1.day
  end
end
