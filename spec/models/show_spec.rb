# To change this template, choose Tools | Templates
# and open the template in the editor.

require 'spec_helper'

describe Show do
  before(:each) do
    @show = Show.new
  end

  it "accept all valid field values" do
    @show.description = 'The show'
    @show.coordinator_id = 1
    @show.venue_id = 1
    @show.start_date = Date.today
    @show.end_date = Date.today + 1.day
    @show.next_start_date = Date.today + 180
    @show.next_end_date = Date.today + 181
    @show.valid?.should be true
  end

  it "should enforce all require field values" do
    @show.valid?.should be false
    @show.errors.count.should be 7
    @show.errors[:description].blank?.should be false
    @show.errors[:coordinator_id].blank?.should be false
    @show.errors[:venue_id].blank?.should be false
    @show.errors[:start_date].blank?.should be false
    @show.errors[:end_date].blank?.should be false
    @show.errors[:next_start_date].blank?.should be false
    @show.errors[:next_end_date].blank?.should be false
  end

  it "should enforce all field length requirements" do
    @show.description = '01234567890123456789012345678901234567890'
    @show.coordinator_id = 1
    @show.venue_id = 1
    @show.start_date = Date.today
    @show.end_date = Date.today + 1.day
    @show.next_start_date = Date.today + 180
    @show.next_end_date = Date.today + 181
    @show.valid?.should be false
    @show.errors[:description].blank?.should be false
  end

  it "should allow default show dates to be calculated from a specified date" do
    @show.description = 'The show'
    @show.coordinator_id = 1
    @show.venue_id = 1
    @show.set_default_dates(Date.parse('2010-09-01'))
    @show.valid?.should be true
    @show.start_date.should == Date.parse('2010-09-11')
    @show.end_date.should == Date.parse('2010-09-12')
    @show.next_start_date.should == Date.parse('2011-03-05')
    @show.next_end_date.should == Date.parse('2011-03-06')
  end
  
end

