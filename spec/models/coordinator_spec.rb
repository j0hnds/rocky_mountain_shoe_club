require 'spec_helper'

describe Coordinator do
  before(:each) do
    @coordinator = Coordinator.new
  end

  it "should allow valid values to be set" do
    @coordinator.first_name = 'Name'
    @coordinator.last_name = 'LastName'
    @coordinator.phone = '303-333-3333'
    @coordinator.email = 'name@something.com'
    @coordinator.valid?.should be true
  end

  it "should ensure that all required fields have been specified" do
    @coordinator.valid? # .should be false
    @coordinator.errors.count.should be 4
    @coordinator.errors[:first_name].blank?.should_not be true
    @coordinator.errors[:last_name].blank?.should_not be true
    @coordinator.errors[:phone].blank?.should_not be true
    @coordinator.errors[:email].blank?.should_not be true
  end

  it "should ensure that the lengths of all the fields are valid" do
    @coordinator.first_name = 'NameNameNameNameNameNameNameNameNameNameName'
    @coordinator.last_name = 'LastNameLastNameLastNameLastNameLastNameLastName'
    @coordinator.phone = '303-333-3333'
    @coordinator.email = 'name01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789@something.com'
    @coordinator.valid?.should be false
    @coordinator.errors.count.should be 3
    @coordinator.errors[:first_name].blank?.should_not be true
    @coordinator.errors[:last_name].blank?.should_not be true
    @coordinator.errors[:email].blank?.should_not be true
  end

  it "should ensure that the phone number is properly formatted" do
    @coordinator.first_name = 'Name'
    @coordinator.last_name = 'LastName'
    @coordinator.phone = '303-333-abcd'
    @coordinator.email = 'name@something.com'
    @coordinator.valid?.should be false
    @coordinator.errors.count.should be 1
    @coordinator.errors[:phone].blank?.should_not be true
  end

  it "should ensure that the email address is properly formatted" do
    @coordinator.first_name = 'Name'
    @coordinator.last_name = 'LastName'
    @coordinator.phone = '303-333-3333'
    @coordinator.email = 'namesomething.com'
    @coordinator.valid?.should be false
    @coordinator.errors.count.should be 1
    @coordinator.errors[:email].blank?.should_not be true
  end

  it "the search_for named scope should allow case independent searching by first name" do
    coordinators = []
    coordinators << Factory.create(:coordinator, :first_name => 'Jerry', :last_name => 'Jones')
    coordinators << Factory.create(:coordinator, :first_name => 'Henry', :last_name => 'Smith')

    search_results = Coordinator.search_for('jer')
    search_results.should_not be nil
    search_results.size.should be 1
    search_results[0].first_name == 'Jerry'
  end

  it "the search_for named scope should allow case independent searching by last name" do
    coordinators = []
    coordinators << Factory.create(:coordinator, :first_name => 'Jerry', :last_name => 'Jones')
    coordinators << Factory.create(:coordinator, :first_name => 'Henry', :last_name => 'Smith')

    search_results = Coordinator.search_for('smi')
    search_results.should_not be nil
    search_results.size.should be 1
    search_results[0].first_name == 'Henry'
  end

  it "the search_for named scope should return the full list when empty" do
    coordinators = []
    coordinators << Factory.create(:coordinator, :first_name => 'Jerry', :last_name => 'Jones')
    coordinators << Factory.create(:coordinator, :first_name => 'Henry', :last_name => 'Smith')

    search_results = Coordinator.search_for('')
    search_results.should_not be nil
    search_results.size.should be 2
  end

  it "the search_for named scope should return the full list when nil" do
    coordinators = []
    coordinators << Factory.create(:coordinator, :first_name => 'Jerry', :last_name => 'Jones')
    coordinators << Factory.create(:coordinator, :first_name => 'Henry', :last_name => 'Smith')

    search_results = Coordinator.search_for(nil)
    search_results.should_not be nil
    search_results.size.should be 2
  end

  it "the ordered named scope should return the coordinators ordered by last name first, then first name" do
    coordinators = []
    coordinators << Factory.create(:coordinator, :first_name => 'Jerry', :last_name => 'Jones')
    coordinators << Factory.create(:coordinator, :first_name => 'Henry', :last_name => 'Smith')
    coordinators << Factory.create(:coordinator, :first_name => 'Isaac', :last_name => 'Jones')

    ordered_coordinators = Coordinator.ordered
    ordered_coordinators.should_not be nil
    ordered_coordinators.size.should == coordinators.size
    ordered_coordinators[0].first_name.should == 'Isaac'
    ordered_coordinators[1].first_name.should == 'Jerry'
    ordered_coordinators[2].first_name.should == 'Henry'
  end

end

