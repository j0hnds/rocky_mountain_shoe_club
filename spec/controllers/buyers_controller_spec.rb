require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe BuyersController do

  before(:each) do
    # Create a store for the buyers
    @store = Factory.create(:store)
  end

  it "retrieve a list of buyers for the index action" do
    # Create two buyers
    buyers = []
    buyers << Factory.create(:buyer, { :store => @store })
    buyers << Factory.create(:buyer, { :store => @store })

    get :index
    assigns[:buyers].should_not be nil
    assigns[:buyers].size.should == buyers.size
    response.should render_template(:index)
  end

  it "returns a new buyer for the new action" do
    get :new
    buyer = assigns[:buyer]
    buyer.should_not be nil
    buyer.new_record?.should be true

    response.should render_template(:new)
  end

  it "should save a valid buyer for the create action" do
    post :create, {
      :buyer => {
        :first_name => 'Jim',
        :last_name => 'Storch',
        :phone => '202-222-2222',
        :email => 'jim.storch@mail.com',
        :store_id => @store.id
      }
    }
    buyer = assigns[:buyer]
    buyer.should_not be nil
    buyer.new_record?.should be false
    buyer.first_name.should == 'Jim'
    buyer.last_name.should == 'Storch'
    buyer.phone.should == '202-222-2222'
    buyer.email.should == 'jim.storch@mail.com'
    buyer.store_id.should be @store.id

    response.should render_template(:success)
  end

  it "should report errors when no valid data is passed to create the buyer" do
    post :create, {
      :buyer => {
        :first_name => '',
        :last_name => '',
        :phone => '',
        :email => '',
        :store_id => ''
      }
    }
    buyer = assigns[:buyer]
    buyer.should_not be nil
    buyer.new_record?.should be true
    buyer.first_name.should == ''
    buyer.last_name.should == ''
    buyer.phone.should == ''
    buyer.email.should == ''
    buyer.store_id.should be nil

    response.should render_template(:failure)
  end

  it "should load the appropriate buyer when asked to edit" do
    buyer1 = Factory.create(:buyer, { :store => @store })

    get :edit, { :id => buyer1.id }
    buyer = assigns[:buyer]
    buyer.should_not be nil
    buyer.new_record?.should be false

    buyer.first_name.should == buyer1.first_name
    buyer.last_name.should == buyer1.last_name
    buyer.phone.should == buyer1.phone
    buyer.email.should == buyer1.email
    buyer.store_id.should == buyer1.store_id

    response.should render_template(:edit)
  end

  it "should update the buyer fields as appropriate for the specified request" do
    buyer1 = Factory.create(:buyer, { :store => @store })

    put :update, { 
      :id => buyer1.id,
      :buyer => {
        :first_name => 'Jim',
        :last_name => 'Storch',
        :phone => '303-333-3333',
        :email => 'jim.storch@mail.com',
        :store_id => @store.id
      }
    }
    buyer = assigns[:buyer]
    buyer.should_not be nil
    buyer.new_record?.should be false

    buyer.first_name.should == 'Jim'
    buyer.last_name.should == 'Storch'
    buyer.phone.should == '303-333-3333'
    buyer.email.should == 'jim.storch@mail.com'
    buyer.store_id.should == @store.id

    response.should render_template(:success)
  end

  it "should error out when modifying a buyer record with bad values" do
    buyer1 = Factory.create(:buyer, { :store => @store })

    put :update, {
      :id => buyer1.id,
      :buyer => {
        :first_name => '',
        :last_name => '',
        :phone => '',
        :email => '',
        :store_id => ''
      }
    }
    buyer = assigns[:buyer]
    buyer.should_not be nil
    buyer.new_record?.should be false

    buyer.first_name.should == ''
    buyer.last_name.should == ''
    buyer.phone.should == ''
    buyer.email.should == ''
    buyer.store_id.should be nil

    response.should render_template(:failure)
  end


end
