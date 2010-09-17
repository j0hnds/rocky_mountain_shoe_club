# To change this template, choose Tools | Templates
# and open the template in the editor.

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Store do
  before(:each) do
    @store = Store.new
  end

  it "should allow all valid fields to be set" do
    @store.name = 'The store'
    @store.address_1 = '123 Main Street'
    @store.address_2 = 'PO Box 111'
    @store.city = 'Denver'
    @store.state = 'CO'
    @store.postal_code = '80126-111'
    @store.phone = '111-111-1111'
    @store.fax = '222-222-2222'
    @store.email = 'store@mail.com'
    @store.valid?.should be true
  end

  it "should enforce all required fields" do
    @store.valid?.should be false
    @store.errors.count.should be 5
    @store.errors[:name].blank?.should be false
    @store.errors[:address_1].blank?.should be false
    @store.errors[:city].blank?.should be false
    @store.errors[:state].blank?.should be false
    @store.errors[:postal_code].blank?.should be false
  end

  it "should enforce attribute length requirements" do
    @store.name = '01234567890123456789012345678901234567890'
    @store.address_1 = '01234567890123456789012345678901234567890'
    @store.address_2 = '01234567890123456789012345678901234567890'
    @store.city = '01234567890123456789012345678901234567890'
    @store.state = 'COa'
    @store.postal_code = '80126-111abcd'
    @store.phone = '111-111-1111aa'
    @store.fax = '222-222-2222aa'
    @store.email = '0123456789@0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789'
    @store.valid?.should be false
    @store.errors.count.should be 13
    @store.errors[:name].blank?.should be false
    @store.errors[:address_1].blank?.should be false
    @store.errors[:address_2].blank?.should be false
    @store.errors[:city].blank?.should be false
    @store.errors[:state].blank?.should be false
    @store.errors[:postal_code].blank?.should be false
    @store.errors[:phone].blank?.should be false
    @store.errors[:fax].blank?.should be false
    @store.errors[:email].blank?.should be false
  end

  it "should enforce the validation of postal codes" do
    @store.name = 'The hotel'
    @store.address_1 = '123 Main Street'
    @store.address_2 = 'PO Box 111'
    @store.city = 'Denver'
    @store.state = 'CO'
    @store.postal_code = '80126'
    @store.phone = '111-111-1111'
    @store.fax = '222-222-2222'
    @store.email = 'store@mail.com'
    @store.valid?.should be true
    @store.postal_code = '80126-11111'
    @store.valid?.should be true
    @store.postal_code = '80126-bbbbb'
    @store.valid?.should be false
    @store.errors[:postal_code].blank?.should be false
  end

  it "should enforce the validation of phone numbers" do
    @store.name = 'The hotel'
    @store.address_1 = '123 Main Street'
    @store.address_2 = 'PO Box 111'
    @store.city = 'Denver'
    @store.state = 'CO'
    @store.postal_code = '80126'
    @store.phone = '11111-1-1111'
    @store.fax = '222-222222-2'
    @store.email = 'store@mail.com'
    @store.valid?.should be false
    @store.errors.count.should be 2
    @store.errors[:phone].blank?.should be false
    @store.errors[:fax].blank?.should be false
  end

  it "should enforce the validation of email addresses" do
    @store.name = 'The store'
    @store.address_1 = '123 Main Street'
    @store.address_2 = 'PO Box 111'
    @store.city = 'Denver'
    @store.state = 'CO'
    @store.postal_code = '80126-111'
    @store.phone = '111-111-1111'
    @store.fax = '222-222-2222'
    @store.email = 'store-mail.com'
    @store.valid?.should be false
    @store.errors.count.should be 1
    @store.errors[:email].blank?.should be false
  end

  it "the search_for named scope should allow case independent searching by name" do
    stores = []
    stores << Factory.create(:store, :name => 'Big Store')
    stores << Factory.create(:store, :name => 'Little Store')

    search_results = Store.search_for('lit')
    search_results.should_not be nil
    search_results.size.should be 1
    search_results[0].name == 'Listtle Store'
  end

  it "the search_for named scope should return the full list when empty" do
    stores = []
    stores << Factory.create(:store, :name => 'Big Store')
    stores << Factory.create(:store, :name => 'Little Store')

    search_results = Store.search_for('')
    search_results.should_not be nil
    search_results.size.should be 2
  end

  it "the search_for named scope should return the full list when nil" do
    stores = []
    stores << Factory.create(:store, :name => 'Big Store')
    stores << Factory.create(:store, :name => 'Little Store')

    search_results = Store.search_for(nil)
    search_results.should_not be nil
    search_results.size.should be 2
  end

  it "the ordered named scope should return the buyers ordered by last name first, then first name" do
    stores = []
    stores << Factory.create(:store, :name => 'Big Store')
    stores << Factory.create(:store, :name => 'Little Store')

    ordered_stores = Store.ordered
    ordered_stores.should_not be nil
    ordered_stores.size.should == stores.size
    ordered_stores[0].name.should == 'Big Store'
    ordered_stores[1].name.should == 'Little Store'
  end

end

