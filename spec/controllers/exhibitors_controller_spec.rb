# To change this template, choose Tools | Templates
# and open the template in the editor.

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ExhibitorsController do
  before(:each) do
#    @exhibitors_controller = ExhibitorsController.new
  end

  it "retrieve a list of exhibitors for the index action" do
    # Create two coordinators
    exhibitors = []
    exhibitors << Factory.create(:exhibitor)
    exhibitors << Factory.create(:exhibitor)

    get :index
    assigns[:exhibitors].should_not be nil
    assigns[:exhibitors].size.should == exhibitors.size
    response.should render_template(:index)
  end

  it "returns a new exhibitor for the new action" do
    get :new
    exhibitor = assigns[:exhibitor]
    exhibitor.should_not be nil
    exhibitor.new_record?.should be true
    response.should render_template(:new)
  end

  it "should save a valid exhibitor for the update action" do
    post :create, { 
      :exhibitor => {
        :first_name => 'jim',
        :last_name => 'jones',
        :address_1 => '111 Main Street',
        :city => 'Grenoble',
        :state => 'GA',
        :postal_code => '90999'}}
    exhibitor = assigns[:exhibitor]
    exhibitor.should_not be nil
    exhibitor.new_record?.should be false
    exhibitor.first_name.should == 'jim'
    exhibitor.last_name.should == 'jones'
    exhibitor.address_1.should == '111 Main Street'
    exhibitor.city.should == 'Grenoble'
    exhibitor.state.should == 'GA'
    exhibitor.postal_code.should == '90999'

    response.should render_template(:success)
  end

  it "should report errors when no valid data is passed to create the exhibitor" do
    post :create, { 
      :exhibitor => {
        :first_name => '',
        :last_name => '',
        :address_1 => '',
        :city => '',
        :state => '',
        :postal_code => ''
        }}
    exhibitor = assigns[:exhibitor]
    exhibitor.should_not be nil
    exhibitor.new_record?.should be true
    exhibitor.first_name.should == ''
    exhibitor.last_name.should == ''
    exhibitor.address_1 == ''
    exhibitor.city == ''
    exhibitor.state == ''
    exhibitor.postal_code == ''

    response.should render_template(:failure)
  end

  it "should load the appropriate exhibitor when asked to edit" do
    exhibitor1 = Factory.create(:exhibitor)

    get :edit, { :id => exhibitor1.id }
    exhibitor = assigns[:exhibitor]
    exhibitor.should_not be nil
    exhibitor.new_record?.should be false

    exhibitor.first_name.should == exhibitor1.first_name
    exhibitor.last_name.should == exhibitor1.last_name
    exhibitor.address_1.should == exhibitor1.address_1
    exhibitor.city.should == exhibitor1.city
    exhibitor.state.should == exhibitor1.state
    exhibitor.postal_code.should == exhibitor1.postal_code

    response.should render_template(:edit)
  end

  it "should update the exhibitor fields as appropriate for the specified request" do
    exhibitor1 = Factory.create(:exhibitor)

    put :update, { 
      :id => exhibitor1.id,
      :exhibitor => {
        :first_name => 'jim',
        :last_name => 'jones',
        :phone => '999-999-9999',
        :email => 'jim.jones@mail.com'
                   }
    }
    exhibitor = assigns[:exhibitor]
    exhibitor.should_not be nil
    exhibitor.new_record?.should be false

    exhibitor.first_name.should == 'jim'
    exhibitor.last_name.should == 'jones'
    exhibitor.phone.should == '999-999-9999'
    exhibitor.email.should == 'jim.jones@mail.com'

    response.should render_template(:success)
  end

  it "should error out when modifying an exhibitor record with bad values" do
    exhibitor1 = Factory.create(:exhibitor)

    put :update, { 
      :id => exhibitor1.id,
      :exhibitor => {
        :first_name => '',
        :last_name => '',
        :phone => '999-abc-9999',
        :email => 'jim.jonesmail.com'
      }
    }
    exhibitor = assigns[:exhibitor]
    exhibitor.should_not be nil
    exhibitor.new_record?.should be false

    exhibitor.first_name.should == ''
    exhibitor.last_name.should == ''
    exhibitor.phone.should == '999-abc-9999'
    exhibitor.email.should == 'jim.jonesmail.com'

    response.should render_template(:failure)
  end
end

