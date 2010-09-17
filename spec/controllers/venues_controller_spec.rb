# To change this template, choose Tools | Templates
# and open the template in the editor.

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe VenuesController do
  before(:each) do
#    @venues_controller = VenuesController.new
  end

  it "retrieve a list of venues for the index action" do
    # Create two venues
    venues = []
    venues << Factory.create(:venue)
    venues << Factory.create(:venue)

    get :index
    assigns[:venues].should_not be nil
    assigns[:venues].size.should == venues.size
    response.should render_template(:index)
  end

  it "should return all the venues when no search term is specified" do
    venues = []
    venues << Factory.create(:venue)
    venues << Factory.create(:venue)

    post :search , { :search => ''}
    assigns[:venues].should_not be nil
    assigns[:venues].size.should == venues.size
    response.should render_template(:success)
  end

  it "should return the correct venue when a search term is specified" do
    venues = []
    venues << Factory.create(:venue, :name => 'Big Hotel')
    venues << Factory.create(:venue, :name => 'Little Hotel')

    post :search , { :search => 'big'}
    assigns[:venues].should_not be nil
    assigns[:venues].size.should == 1
    assigns[:venues][0].name.should == 'Big Hotel'
    response.should render_template(:success)
  end

  it "should return no venues when a bogus search term is specified" do
    venues = []
    venues << Factory.create(:venue, :name => 'Big Hotel')
    venues << Factory.create(:venue, :name => 'Little Hotel')

    post :search , { :search => 'hair'}
    assigns[:venues].should_not be nil
    assigns[:venues].size.should == 0
    response.should render_template(:success)
  end

  it "when a search term has been specified, it should remain in session until cleared" do
    venues = []
    venues << Factory.create(:venue, :name => 'Big Hotel')
    venues << Factory.create(:venue, :name => 'Little Hotel')

    post :search , { :search => 'big'}
    assigns[:venues].should_not be nil
    assigns[:venues].size.should == 1
    assigns[:venues][0].name.should == 'Big Hotel'
    response.should render_template(:success)

    # Now, re-view the venues index page; the search term should still be in
    # effect
    get :index
    assigns[:venues].should_not be nil
    assigns[:venues].size.should == 1
    assigns[:venues][0].name.should == 'Big Hotel'
    response.should render_template(:index)

    # Clear the search term
    post :search , { :search => ''}

    get :index
    assigns[:venues].should_not be nil
    assigns[:venues].size.should == venues.size
    response.should render_template(:index)
  end

  it "returns a new venue for the new action" do
    get :new
    venue = assigns[:venue]
    venue.should_not be nil
    venue.new_record?.should be true
    response.should render_template(:new)
  end

  it "should save a valid venue for the update action" do
    post :create, { 
      :venue => {
        :name => 'Hotel',
        :address_1 => 'addr1',
        :address_2 => 'addr2',
        :city => 'sanfran',
        :state => 'CA',
        :postal_code => '90111-123',
        :phone => '303-333-3333',
        :fax => '202-222-2222',
        :reservation => '888-888-8888'}}
    venue = assigns[:venue]
    venue.should_not be nil
    venue.new_record?.should be false
    venue.name.should == 'Hotel'
    venue.address_1.should == 'addr1'
    venue.address_2.should == 'addr2'
    venue.city.should == 'sanfran'
    venue.state.should == 'CA'
    venue.postal_code.should == '90111-123'
    venue.phone.should == '303-333-3333'
    venue.fax.should == '202-222-2222'
    venue.reservation.should == '888-888-8888'

    venues = assigns[:venues]
    venues.should_not be nil
    venues.size.should == 1

    response.should render_template(:success)
  end

  it "should report errors when no valid data is passed to create the venue" do
    post :create, {
      :venue => {
        :name => '',
        :address_1 => '',
        :address_2 => '',
        :city => '',
        :state => '',
        :postal_code => '-123',
        :phone => '303-333-',
        :fax => '202--2222',
        :reservation => '-888-8888'}}
    venue = assigns[:venue]
    venue.should_not be nil
    venue.new_record?.should be true
    venue.name.should == ''
    venue.address_1.should == ''
    venue.address_2.should == ''
    venue.city.should == ''
    venue.state.should == ''
    venue.postal_code.should == '-123'
    venue.phone.should == '303-333-'
    venue.fax.should == '202--2222'
    venue.reservation.should == '-888-8888'

    response.should render_template(:failure)
  end

  it "should load the appropriate venue when asked to edit" do
    venue1 = Factory.create(:venue)

    get :edit, { :id => venue1.id }
    venue = assigns[:venue]
    venue.should_not be nil
    venue.new_record?.should be false

    venue.name.should == venue1.name
    venue.address_1.should == venue1.address_1
    venue.address_2.should == venue1.address_2
    venue.city.should == venue1.city
    venue.state.should == venue1.state
    venue.postal_code.should == venue1.postal_code
    venue.phone.should == venue1.phone
    venue.fax.should == venue1.fax
    venue.reservation.should == venue1.reservation

    response.should render_template(:edit)
  end

  it "should update the venue fields as appropriate for the specified request" do
    venue1 = Factory.create(:venue)

    put :update, { 
      :id => venue1.id,
      :venue => {
         :name => 'Different Hotel',
         :address_1 => 'addr 111',
         :address_2 => 'addr 222',
         :city => 'denver',
         :state => 'co',
         :postal_code => '99011',
         :phone => '999-999-9999',
         :fax => '123-123-1234',
         :reservation => '321-321-3210'
       }
    }
    venue = assigns[:venue]
    venue.should_not be nil
    venue.new_record?.should be false

    venue.name.should == 'Different Hotel'
    venue.address_1.should == 'addr 111'
    venue.address_2.should == 'addr 222'
    venue.city.should == 'denver'
    venue.state.should == 'co'
    venue.postal_code.should == '99011'
    venue.phone.should == '999-999-9999'
    venue.fax.should == '123-123-1234'
    venue.reservation.should == '321-321-3210'

    venues = assigns[:venues]
    venues.should_not be nil
    venues.size.should == 1

    response.should render_template(:success)
  end

  it "should error out when modifying a venue record with bad values" do
    venue1 = Factory.create(:venue)

    put :update, { 
      :id => venue1.id,
      :venue => {
         :name => '',
         :address_1 => '',
         :address_2 => '',
         :city => '',
         :state => '',
         :postal_code => '990aa',
         :phone => '999-999-',
         :fax => '123--1234',
         :reservation => '-321-3210'
       }
    }
    venue = assigns[:venue]
    venue.should_not be nil
    venue.new_record?.should be false

    venue.name.should == ''
    venue.address_1.should == ''
    venue.address_2.should == ''
    venue.city.should == ''
    venue.state.should == ''
    venue.postal_code.should == '990aa'
    venue.phone.should == '999-999-'
    venue.fax.should == '123--1234'
    venue.reservation.should == '-321-3210'

    response.should render_template(:failure)
  end
end

