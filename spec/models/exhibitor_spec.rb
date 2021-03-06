# To change this template, choose Tools | Templates
# and open the template in the editor.

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Exhibitor do
  before(:each) do
    @exhibitor = Exhibitor.new
  end

  it "should allow valid values to be set" do
    @exhibitor.first_name = 'Name'
    @exhibitor.last_name = 'LastName'
    @exhibitor.address_1 = '121 Main'
    @exhibitor.address_2 = 'PO Box 12'
    @exhibitor.city = 'Denver'
    @exhibitor.state = 'CO'
    @exhibitor.postal_code = '90000-11'
    @exhibitor.email = 'name@something.com'
    @exhibitor.phone = '303-333-3333'
    @exhibitor.fax = '303-333-3333'
    @exhibitor.cell = '303-333-3333'
    @exhibitor.valid?.should be true
  end

  it "should ensure that all required fields have been specified" do
    @exhibitor.valid?.should be false
    @exhibitor.errors.count.should be 6
    @exhibitor.errors[:first_name].blank?.should_not be true
    @exhibitor.errors[:last_name].blank?.should_not be true
    @exhibitor.errors[:address_1].blank?.should_not be true
    @exhibitor.errors[:city].blank?.should_not be true
    @exhibitor.errors[:state].blank?.should_not be true
    @exhibitor.errors[:postal_code].blank?.should_not be true
  end

  it "should ensure that the lengths of all the fields are valid" do
    @exhibitor.first_name = 'NameNameNameNameNameNameNameNameNameNameName'
    @exhibitor.last_name = 'LastNameLastNameLastNameLastNameLastNameLastName'
    @exhibitor.address_1 = '01234567890123456789012345678901234567890'
    @exhibitor.address_2 = '01234567890123456789012345678901234567890'
    @exhibitor.city = '01234567890123456789012345678901234567890'
    @exhibitor.state = 'abc'
    @exhibitor.postal_code = '9000000'
    @exhibitor.email = 'name01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789@something.com'
    @exhibitor.phone = '303-333-3333'
    @exhibitor.fax = '303-333-3333'
    @exhibitor.cell = '303-333-3333'
    @exhibitor.valid?.should be false
    @exhibitor.errors.count.should be 8
    @exhibitor.errors[:first_name].blank?.should_not be true
    @exhibitor.errors[:last_name].blank?.should_not be true
    @exhibitor.errors[:address_1].blank?.should_not be true
    @exhibitor.errors[:address_2].blank?.should_not be true
    @exhibitor.errors[:city].blank?.should_not be true
    @exhibitor.errors[:state].blank?.should_not be true
    @exhibitor.errors[:postal_code].blank?.should_not be true
    @exhibitor.errors[:email].blank?.should_not be true
  end

  it "should ensure that the phone numbers are properly formatted" do
    @exhibitor.first_name = 'Name'
    @exhibitor.last_name = 'LastName'
    @exhibitor.address_1 = '121 Main'
    @exhibitor.address_2 = 'PO Box 12'
    @exhibitor.city = 'Denver'
    @exhibitor.state = 'CO'
    @exhibitor.postal_code = '90000-11'
    @exhibitor.email = 'name@something.com'
    @exhibitor.phone = '303-333-abcd'
    @exhibitor.fax = '303--3333'
    @exhibitor.cell = '-333-3333'
    @exhibitor.valid?.should be false
    @exhibitor.errors.count.should be 3
    @exhibitor.errors[:phone].blank?.should_not be true
    @exhibitor.errors[:fax].blank?.should_not be true
    @exhibitor.errors[:cell].blank?.should_not be true
  end

  it "should ensure that the email address is properly formatted" do
    @exhibitor.first_name = 'Name'
    @exhibitor.last_name = 'LastName'
    @exhibitor.address_1 = '121 Main'
    @exhibitor.address_2 = 'PO Box 12'
    @exhibitor.city = 'Denver'
    @exhibitor.state = 'CO'
    @exhibitor.postal_code = '90000-11'
    @exhibitor.email = 'name.something.com'
    @exhibitor.phone = '303-333-3333'
    @exhibitor.fax = '303-333-3333'
    @exhibitor.cell = '303-333-3333'
    @exhibitor.valid?.should be false
    @exhibitor.errors.count.should be 1
    @exhibitor.errors[:email].blank?.should_not be true
  end

  it "the search_for named scope should allow case independent searching by first name" do
    exhibitors = []
    exhibitors << Factory.create(:exhibitor, :first_name => 'Jerry', :last_name => 'Jones')
    exhibitors << Factory.create(:exhibitor, :first_name => 'Henry', :last_name => 'Smith')

    search_results = Exhibitor.search_for('jer')
    search_results.should_not be nil
    search_results.size.should be 1
    search_results[0].first_name == 'Jerry'
  end

  it "the search_for named scope should allow case independent searching by last name" do
    exhibitors = []
    exhibitors << Factory.create(:exhibitor, :first_name => 'Jerry', :last_name => 'Jones')
    exhibitors << Factory.create(:exhibitor, :first_name => 'Henry', :last_name => 'Smith')

    search_results = Exhibitor.search_for('smi')
    search_results.should_not be nil
    search_results.size.should be 1
    search_results[0].first_name == 'Henry'
  end

  it "the search_for named scope should return the full list when empty" do
    exhibitors = []
    exhibitors << Factory.create(:exhibitor, :first_name => 'Jerry', :last_name => 'Jones')
    exhibitors << Factory.create(:exhibitor, :first_name => 'Henry', :last_name => 'Smith')

    search_results = Exhibitor.search_for('')
    search_results.should_not be nil
    search_results.size.should be 2
  end

  it "the search_for named scope should return the full list when nil" do
    exhibitors = []
    exhibitors << Factory.create(:exhibitor, :first_name => 'Jerry', :last_name => 'Jones')
    exhibitors << Factory.create(:exhibitor, :first_name => 'Henry', :last_name => 'Smith')

    search_results = Exhibitor.search_for(nil)
    search_results.should_not be nil
    search_results.size.should be 2
  end

  it "the ordered named scope should return the buyers ordered by last name first, then first name" do
    exhibitors = []
    exhibitors << Factory.create(:exhibitor, :first_name => 'Jerry', :last_name => 'Jones')
    exhibitors << Factory.create(:exhibitor, :first_name => 'Henry', :last_name => 'Smith')
    exhibitors << Factory.create(:exhibitor, :first_name => 'Isaac', :last_name => 'Jones')

    ordered_exhibitors = Exhibitor.ordered
    ordered_exhibitors.should_not be nil
    ordered_exhibitors.size.should == exhibitors.size
    ordered_exhibitors[0].first_name.should == 'Isaac'
    ordered_exhibitors[1].first_name.should == 'Jerry'
    ordered_exhibitors[2].first_name.should == 'Henry'
  end

end

