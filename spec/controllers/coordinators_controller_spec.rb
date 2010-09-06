# To change this template, choose Tools | Templates
# and open the template in the editor.

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe CoordinatorsController do
  before(:each) do
#    @coordinators_controller = CoordinatorsController.new
  end

  it "retrieve a list of users for the show action" do
    # Create two coordinators
    coordinators = []
    coordinators << Factory.create(:coordinator)
    coordinators << Factory.create(:coordinator)

    get :index
    assigns[:coordinators].should_not be nil
    assigns[:coordinators].size.should == coordinators.size
    response.should render_template(:index)
  end

  it "returns a new coordinator for the new action" do
    get :new
    coordinator = assigns[:coordinator]
    coordinator.should_not be nil
    coordinator.new_record?.should be true
    response.should render_template(:new)
  end

  it "should save a valid coordinator for the update action" do
    post :create, { :coordinator => { :first_name => 'jim',
                                      :last_name => 'jones',
                                      :phone => '303-333-3333',
                                      :email => 'jim.jones@mail.com'}}
    coordinator = assigns[:coordinator]
    coordinator.should_not be nil
    coordinator.new_record?.should be false
    coordinator.first_name.should == 'jim'
    coordinator.last_name.should == 'jones'
    coordinator.phone.should == '303-333-3333'
    coordinator.email.should == 'jim.jones@mail.com'

    response.should render_template(:success)
  end

  it "should report errors when no valid data is passed to create the coordinator" do
    post :create, { :coordinator => { :first_name => '',
                                      :last_name => '',
                                      :phone => '303-abc-3333',
                                      :email => 'jim.jonesmail.com'}}
    coordinator = assigns[:coordinator]
    coordinator.should_not be nil
    coordinator.new_record?.should be true
    coordinator.first_name.should == ''
    coordinator.last_name.should == ''
    coordinator.phone.should == '303-abc-3333'
    coordinator.email.should == 'jim.jonesmail.com'

    response.should render_template(:failure)
  end

  it "should load the appropriate coordinator when asked to edit" do
    coord1 = Factory.create(:coordinator)

    get :edit, { :id => coord1.id }
    coordinator = assigns[:coordinator]
    coordinator.should_not be nil
    coordinator.new_record?.should be false

    coordinator.first_name.should == coord1.first_name
    coordinator.last_name.should == coord1.last_name
    coordinator.phone.should == coord1.phone
    coordinator.email.should == coord1.email

    response.should render_template(:edit)
  end

  it "should update the coordinator fields as appropriate for the specified request" do
    coord1 = Factory.create(:coordinator)

    put :update, { :id => coord1.id,
                   :coordinator => {
                     :first_name => 'jim',
                     :last_name => 'jones',
                     :phone => '999-999-9999',
                     :email => 'jim.jones@mail.com'
                   }
    }
    coordinator = assigns[:coordinator]
    coordinator.should_not be nil
    coordinator.new_record?.should be false

    coordinator.first_name.should == 'jim'
    coordinator.last_name.should == 'jones'
    coordinator.phone.should == '999-999-9999'
    coordinator.email.should == 'jim.jones@mail.com'

    response.should render_template(:success)
  end

  it "should error out when modifying a coordinator record with bad values" do
    coord1 = Factory.create(:coordinator)

    put :update, { :id => coord1.id,
                   :coordinator => {
                     :first_name => '',
                     :last_name => '',
                     :phone => '999-abc-9999',
                     :email => 'jim.jonesmail.com'
                   }
    }
    coordinator = assigns[:coordinator]
    coordinator.should_not be nil
    coordinator.new_record?.should be false

    coordinator.first_name.should == ''
    coordinator.last_name.should == ''
    coordinator.phone.should == '999-abc-9999'
    coordinator.email.should == 'jim.jonesmail.com'

    response.should render_template(:failure)
  end

end

