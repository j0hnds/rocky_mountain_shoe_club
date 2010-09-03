# To change this template, choose Tools | Templates
# and open the template in the editor.

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ShowsController do
  before(:each) do
#    @shows_controller = ShowsController.new
  end

  it "retrieve a list of shows for the index action" do
    # Create two shows
    coordinator = Factory.create(:coordinator)
    venue = Factory.create(:venue)
    shows = []
    shows << Factory.create(:show, { :coordinator => coordinator, :venue => venue })
    shows << Factory.create(:show, { :coordinator => coordinator, :venue => venue })

    get :index
    assigns[:shows].should_not be nil
    assigns[:shows].size.should == shows.size
    response.should render_template(:index)
  end

  it "returns a new show for the new action" do
    get :new
    show = assigns[:show]
    show.should_not be nil
    show.new_record?.should be true

    # The dates for this show and the next show should be defaulted
    show_start_date = next_show_date
    show_end_date = show_start_date + 1.day

    show_next_start_date = next_show_date(show_end_date)
    show_next_end_date = show_next_start_date + 1.day

    show.start_date.should == show_start_date
    show.end_date.should == show_end_date
    show.next_start_date.should == show_next_start_date
    show.next_end_date.should == show_next_end_date
    
    response.should render_template(:new)
  end

  it "should save a valid show for the create action" do
    coordinator = Factory.create(:coordinator)
    venue = Factory.create(:venue)
    post :create, {
      :show => {
        :description => 'A Show',
        :coordinator_id => coordinator.id,
        :venue_id => venue.id,
        :start_date => '2010-09-01',
        :end_date => '2010-09-02',
        :next_start_date => '2011-03-05',
        :next_end_date => '2011-03-06'
      }
    }
    show = assigns[:show]
    show.should_not be nil
    show.new_record?.should be false
    show.description.should == 'A Show'
    show.coordinator_id.should == coordinator.id
    show.venue_id.should == venue.id
    show.start_date.should == Date.parse('2010-09-01')
    show.end_date.should == Date.parse('2010-09-02')
    show.next_start_date.should == Date.parse('2011-03-05')
    show.next_end_date.should == Date.parse('2011-03-06')

    response.should redirect_to(shows_path)
  end

  it "should report errors when no valid data is passed to create the show" do
    post :create, {
      :show => {
        :description => '',
        :coordinator_id => '',
        :venue_id => '',
        :start_date => '',
        :end_date => '',
        :next_start_date => '',
        :next_end_date => ''
      }
    }
    show = assigns[:show]
    show.should_not be nil
    show.new_record?.should be true
    show.description.should == ''
    show.coordinator_id.should be nil
    show.venue_id.should be nil
    show.start_date.should be nil
    show.end_date.should be nil
    show.next_start_date.should be nil
    show.next_end_date.should be nil

    response.should render_template(:new)
  end

  it "should load the appropriate show when asked to edit" do
    venue = Factory.create(:venue)
    coordinator = Factory.create(:coordinator)
    show1 = Factory.create(:show, { :coordinator => coordinator, :venue => venue })

    get :edit, { :id => show1.id }
    show = assigns[:show]
    show.should_not be nil
    show.new_record?.should be false

    show.description.should == show1.description
    show.coordinator_id.should == show1.coordinator_id
    show.venue_id.should == show1.venue_id
    show.start_date.should == show1.start_date
    show.end_date.should == show1.end_date
    show.next_start_date.should == show1.next_start_date
    show.next_end_date.should == show1.next_end_date

    response.should render_template(:edit)
  end

  it "should update the show fields as appropriate for the specified request" do
    venue1 = Factory.create(:venue)
    coordinator1 = Factory.create(:coordinator)
    venue2 = Factory.create(:venue)
    coordinator2 = Factory.create(:coordinator)
    show1 = Factory.create(:show, { :coordinator => coordinator1, :venue => venue1 })

    put :update, { 
      :id => show1.id,
      :show => {
        :description => 'Different Hotel',
        :coordinator_id => coordinator2.id,
        :venue_id => venue2.id,
        :start_date => '2010-01-01',
        :end_date => '2010-01-02',
        :next_start_date => '2010-01-03',
        :next_end_date => '2010-01-04'
      }
    }
    show = assigns[:show]
    show.should_not be nil
    show.new_record?.should be false

    show.description.should == 'Different Hotel'
    show.coordinator_id.should == coordinator2.id
    show.venue_id.should == venue2.id
    show.start_date.should == Date.parse('2010-01-01')
    show.end_date.should == Date.parse('2010-01-02')
    show.next_start_date.should == Date.parse('2010-01-03')
    show.next_end_date.should == Date.parse('2010-01-04')

    response.should redirect_to(shows_path)
  end

  it "should error out when modifying a show record with bad values" do
    venue = Factory.create(:venue)
    coordinator = Factory.create(:coordinator)
    show1 = Factory.create(:show, { :coordinator => coordinator, :venue => venue })

    put :update, {
      :id => show1.id,
      :show => {
        :description => '',
        :coordinator_id => '',
        :venue_id => '',
        :start_date => '',
        :end_date => '',
        :next_start_date => '',
        :next_end_date => ''
      }
    }
    show = assigns[:show]
    show.should_not be nil
    show.new_record?.should be false

    show.description.should == ''
    show.coordinator_id.should be nil
    show.venue_id.should be nil
    show.start_date.should be nil
    show.end_date.should be nil
    show.next_start_date.should be nil
    show.next_end_date.should be nil

    response.should render_template(:edit)
  end


end

