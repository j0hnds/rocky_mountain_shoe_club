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
end

