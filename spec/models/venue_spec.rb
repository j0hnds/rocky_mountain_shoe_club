# To change this template, choose Tools | Templates
# and open the template in the editor.

require 'spec_helper'

describe Venue do
  before(:each) do
    @venue = Venue.new
  end

  it "should allow all valid fields to be set" do
    @venue.name = 'The hotel'
    @venue.address_1 = '123 Main Street'
    @venue.address_2 = 'PO Box 111'
    @venue.city = 'Denver'
    @venue.state = 'CO'
    @venue.postal_code = '80126-111'
    @venue.phone = '111-111-1111'
    @venue.fax = '222-222-2222'
    @venue.reservation = '333-333-3333'
    @venue.valid?.should be true
  end

  it "should enforce all required fields" do
    @venue.valid?.should be false
    @venue.errors.count.should be 8
    @venue.errors[:name].blank?.should be false
    @venue.errors[:address_1].blank?.should be false
    @venue.errors[:city].blank?.should be false
    @venue.errors[:state].blank?.should be false
    @venue.errors[:postal_code].blank?.should be false
    @venue.errors[:phone].blank?.should be false
    @venue.errors[:fax].blank?.should be false
    @venue.errors[:reservation].blank?.should be false
  end

  it "should enforce attribute length requirements" do
    @venue.name = '01234567890123456789012345678901234567890'
    @venue.address_1 = '01234567890123456789012345678901234567890'
    @venue.address_2 = '01234567890123456789012345678901234567890'
    @venue.city = '01234567890123456789012345678901234567890'
    @venue.state = 'COa'
    @venue.postal_code = '80126-111abcd'
    @venue.phone = '111-111-1111aa'
    @venue.fax = '222-222-2222aa'
    @venue.reservation = '333-333-3333aa'
    @venue.valid?.should be false
    @venue.errors.count.should be 13
    @venue.errors[:name].blank?.should be false
    @venue.errors[:address_1].blank?.should be false
    @venue.errors[:address_2].blank?.should be false
    @venue.errors[:city].blank?.should be false
    @venue.errors[:state].blank?.should be false
    @venue.errors[:postal_code].blank?.should be false
    @venue.errors[:phone].blank?.should be false
    @venue.errors[:fax].blank?.should be false
    @venue.errors[:reservation].blank?.should be false
  end

  it "should enforce the validation of postal codes" do
    @venue.name = 'The hotel'
    @venue.address_1 = '123 Main Street'
    @venue.address_2 = 'PO Box 111'
    @venue.city = 'Denver'
    @venue.state = 'CO'
    @venue.postal_code = '80126'
    @venue.phone = '111-111-1111'
    @venue.fax = '222-222-2222'
    @venue.reservation = '333-333-3333'
    @venue.valid?.should be true
    @venue.postal_code = '80126-11111'
    @venue.valid?.should be true
    @venue.postal_code = '80126-bbbbb'
    @venue.valid?.should be false
    @venue.errors[:postal_code].blank?.should be false
  end

  it "should enforce the validation of phone numbers" do
    @venue.name = 'The hotel'
    @venue.address_1 = '123 Main Street'
    @venue.address_2 = 'PO Box 111'
    @venue.city = 'Denver'
    @venue.state = 'CO'
    @venue.postal_code = '80126'
    @venue.phone = '11111-1-1111'
    @venue.fax = '222-222222-2'
    @venue.reservation = '333333-3333'
    @venue.valid?.should be false
    @venue.errors.count.should be 3
    @venue.errors[:phone].blank?.should be false
    @venue.errors[:fax].blank?.should be false
    @venue.errors[:reservation].blank?.should be false
  end

  it "the search_for named scope should allow case independent searching by name" do
    venues = []
    venues << Factory.create(:venue, :name => 'Big Venue')
    venues << Factory.create(:venue, :name => 'Little Venue')

    search_results = Venue.search_for('lit')
    search_results.should_not be nil
    search_results.size.should be 1
    search_results[0].name == 'Little Venue'
  end

  it "the search_for named scope should return the full list when empty" do
    venues = []
    venues << Factory.create(:venue, :name => 'Big Venue')
    venues << Factory.create(:venue, :name => 'Little Venue')

    search_results = Venue.search_for('')
    search_results.should_not be nil
    search_results.size.should be 2
  end

  it "the search_for named scope should return the full list when nil" do
    venues = []
    venues << Factory.create(:venue, :name => 'Big Venue')
    venues << Factory.create(:venue, :name => 'Little Venue')

    search_results = Venue.search_for(nil)
    search_results.should_not be nil
    search_results.size.should be 2
  end

  it "the ordered named scope should return the buyers ordered by last name first, then first name" do
    venues = []
    venues << Factory.create(:venue, :name => 'Big Venue')
    venues << Factory.create(:venue, :name => 'Little Venue')

    ordered_venues = Venue.ordered
    ordered_venues.should_not be nil
    ordered_venues.size.should == venues.size
    ordered_venues[0].name.should == 'Big Venue'
    ordered_venues[1].name.should == 'Little Venue'
  end

end

