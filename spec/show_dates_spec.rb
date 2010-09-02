require 'spec_helper'
require 'show_dates'

describe 'ShowDates' do
  before(:each) do
  end

  it 'will create the next labor day date after the specified date' do
    labor_day = labor_day_date(Date.parse('2010-09-01'))
    labor_day.should == Date.parse('2010-09-06')
  end

  it 'will create the next march show date after the specified date' do
    march_show = march_show_date(2010)
    march_show.should == Date.parse('2010-03-06')
  end

  it 'will create the next september show date after the specified date' do
    september_show = september_show_date(2010)
    september_show.should == Date.parse('2010-09-11')
  end

  it 'will create the next show date after the specified date' do
    next_show = next_show_date(Date.parse('2010-09-01'))
    next_show.should == Date.parse('2010-09-11')
  end

end