# To change this template, choose Tools | Templates
# and open the template in the editor.

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Buyer do
  before(:each) do
    @buyer = Buyer.new
    @store = Factory.create(:store)
  end

  it "should allow valid values to be set" do
    @buyer.store_id = @store.id
    @buyer.first_name = 'Name'
    @buyer.last_name = 'LastName'
    @buyer.phone = '303-333-3333'
    @buyer.email = 'name@something.com'
    @buyer.valid?.should be true
  end

  it "should ensure that all required fields have been specified" do
    @buyer.valid? # .should be false
    @buyer.errors.count.should be 3
    @buyer.errors[:store_id].blank?.should_not be true
    @buyer.errors[:first_name].blank?.should_not be true
    @buyer.errors[:last_name].blank?.should_not be true
  end

  it "should ensure that the lengths of all the fields are valid" do
    @buyer.store_id = @store.id
    @buyer.first_name = 'NameNameNameNameNameNameNameNameNameNameName'
    @buyer.last_name = 'LastNameLastNameLastNameLastNameLastNameLastName'
    @buyer.phone = '303-333-3333'
    @buyer.email = 'name01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789@something.com'
    @buyer.valid?.should be false
    @buyer.errors.count.should be 3
    @buyer.errors[:first_name].blank?.should_not be true
    @buyer.errors[:last_name].blank?.should_not be true
    @buyer.errors[:email].blank?.should_not be true
  end

  it "should ensure that the phone number is properly formatted" do
    @buyer.store_id = @store.id
    @buyer.first_name = 'Name'
    @buyer.last_name = 'LastName'
    @buyer.phone = '303-333-abcd'
    @buyer.email = 'name@something.com'
    @buyer.valid?.should be false
    @buyer.errors.count.should be 1
    @buyer.errors[:phone].blank?.should_not be true
  end

  it "should ensure that the email address is properly formatted" do
    @buyer.store_id = @store.id
    @buyer.first_name = 'Name'
    @buyer.last_name = 'LastName'
    @buyer.phone = '303-333-3333'
    @buyer.email = 'namesomething.com'
    @buyer.valid?.should be false
    @buyer.errors.count.should be 1
    @buyer.errors[:email].blank?.should_not be true
  end

end

