# To change this template, choose Tools | Templates
# and open the template in the editor.

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe StoresController do
  before(:each) do
#    @stores_controller = StoresController.new
  end

  it "retrieve a list of stores for the index action" do
    # Create two stores
    stores = []
    stores << Factory.create(:store)
    stores << Factory.create(:store)

    get :index
    assigns[:stores].should_not be nil
    assigns[:stores].size.should == stores.size
    response.should render_template(:index)
  end

  it "returns a new store for the new action" do
    get :new
    store = assigns[:store]
    store.should_not be nil
    store.new_record?.should be true
    response.should render_template(:new)
  end

  it "should save a valid store for the create action" do
    post :create, { :store => { :name => 'jim',
                                :address_1 => '123 Main',
                                :city => 'Denver',
                                :state => 'CO',
                                :postal_code => '80111',
                                :phone => '303-333-3333',
                                :email => 'jim.jones@mail.com'}}
    store = assigns[:store]
    store.should_not be nil
    store.new_record?.should be false
    store.name.should == 'jim'
    store.address_1.should == '123 Main'
    store.city.should == 'Denver'
    store.state.should == 'CO'
    store.postal_code == '80111'
    store.phone.should == '303-333-3333'
    store.email.should == 'jim.jones@mail.com'

    response.should render_template(:success)
  end

  it "should report errors when no valid data is passed to create the store" do
    post :create, { :store => { :name => '',
                                :address_1 => '',
                                :city => '',
                                :state => '',
                                :postal_code => ''}}
    store = assigns[:store]
    store.should_not be nil
    store.new_record?.should be true
    store.name.should == ''
    store.address_1.should == ''
    store.city.should == ''
    store.state.should == ''
    store.postal_code.should == ''

    response.should render_template(:failure)
  end

  it "should load the appropriate store when asked to edit" do
    store1 = Factory.create(:store)

    get :edit, { :id => store1.id }
    store = assigns[:store]
    store.should_not be nil
    store.new_record?.should be false

    store.name.should == store1.name
    store.address_1.should == store1.address_1
    store.city.should == store1.city
    store.state.should == store1.state
    store.postal_code.should == store1.postal_code

    response.should render_template(:edit)
  end

  it "should update the store fields as appropriate for the specified request" do
    store1 = Factory.create(:store)

    put :update, { :id => store1.id,
                   :store => {
                     :name => 'jim',
                     :address_1 => '321 Main',
                     :city => 'Township',
                     :state => 'AL',
                     :postal_code => '99900'
                   }
    }
    store = assigns[:store]
    store.should_not be nil
    store.new_record?.should be false

    store.name.should == 'jim'
    store.address_1.should == '321 Main'
    store.city.should == 'Township'
    store.state.should == 'AL'
    store.postal_code.should == '99900'

    response.should render_template(:success)
  end

  it "should error out when modifying a store record with bad values" do
    store1 = Factory.create(:store)

    put :update, { :id => store1.id,
                   :store => {
                     :name => '',
                     :address_1 => '',
                     :city => '',
                     :state => '',
                     :postal_code => ''
                   }
    }
    store = assigns[:store]
    store.should_not be nil
    store.new_record?.should be false

    store.name.should == ''
    store.address_1.should == ''
    store.city.should == ''
    store.state.should == ''
    store.postal_code.should == ''

    response.should render_template(:failure)
  end
end

