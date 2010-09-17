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

  it "the search_for named scope should allow case independent searching by first name" do
    buyers = []
    buyers << Factory.create(:buyer, :store => @store, :first_name => 'Jerry', :last_name => 'Jones')
    buyers << Factory.create(:buyer, :store => @store, :first_name => 'Henry', :last_name => 'Smith')

    search_results = Buyer.search_for('jer')
    search_results.should_not be nil
    search_results.size.should be 1
    search_results[0].first_name == 'Jerry'
  end

  it "the search_for named scope should allow case independent searching by last name" do
    buyers = []
    buyers << Factory.create(:buyer, :store => @store, :first_name => 'Jerry', :last_name => 'Jones')
    buyers << Factory.create(:buyer, :store => @store, :first_name => 'Henry', :last_name => 'Smith')

    search_results = Buyer.search_for('smi')
    search_results.should_not be nil
    search_results.size.should be 1
    search_results[0].first_name == 'Henry'
  end

  it "the search_for named scope should return the full list when empty" do
    buyers = []
    buyers << Factory.create(:buyer, :store => @store, :first_name => 'Jerry', :last_name => 'Jones')
    buyers << Factory.create(:buyer, :store => @store, :first_name => 'Henry', :last_name => 'Smith')

    search_results = Buyer.search_for('')
    search_results.should_not be nil
    search_results.size.should be 2
  end

  it "the search_for named scope should return the full list when nil" do
    buyers = []
    buyers << Factory.create(:buyer, :store => @store, :first_name => 'Jerry', :last_name => 'Jones')
    buyers << Factory.create(:buyer, :store => @store, :first_name => 'Henry', :last_name => 'Smith')

    search_results = Buyer.search_for(nil)
    search_results.should_not be nil
    search_results.size.should be 2
  end

  it "the ordered named scope should return the buyers ordered by last name first, then first name" do
    buyers = []
    buyers << Factory.create(:buyer, :store => @store, :first_name => 'Jerry', :last_name => 'Jones')
    buyers << Factory.create(:buyer, :store => @store, :first_name => 'Henry', :last_name => 'Smith')
    buyers << Factory.create(:buyer, :store => @store, :first_name => 'Isaac', :last_name => 'Jones')

    ordered_buyers = Buyer.ordered
    ordered_buyers.should_not be nil
    ordered_buyers.size.should == buyers.size
    ordered_buyers[0].first_name.should == 'Isaac'
    ordered_buyers[1].first_name.should == 'Jerry'
    ordered_buyers[2].first_name.should == 'Henry'
  end

end

