# To change this template, choose Tools | Templates
# and open the template in the editor.

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ShowsController do
  include ShowDates
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

  it "should return all the shows when no search term is specified" do
    # Create two shows
    coordinator = Factory.create(:coordinator)
    venue = Factory.create(:venue)
    shows = []
    shows << Factory.create(:show, { :coordinator => coordinator, :venue => venue })
    shows << Factory.create(:show, { :coordinator => coordinator, :venue => venue })

    post :search , { :search => ''}
    assigns[:shows].should_not be nil
    assigns[:shows].size.should == shows.size
    response.should render_template(:success)
  end

  it "should return the correct show when a search term is specified" do
    coordinator = Factory.create(:coordinator)
    venue = Factory.create(:venue)
    shows = []
    shows << Factory.create(:show, { :description => 'Big Show', :coordinator => coordinator, :venue => venue })
    shows << Factory.create(:show, { :description => 'Little Show', :coordinator => coordinator, :venue => venue })

    post :search , { :search => 'big'}
    assigns[:shows].should_not be nil
    assigns[:shows].size.should == 1
    assigns[:shows][0].description.should == 'Big Show'
    response.should render_template(:success)
  end

  it "should return no shows when a bogus search term is specified" do
    coordinator = Factory.create(:coordinator)
    venue = Factory.create(:venue)
    shows = []
    shows << Factory.create(:show, { :description => 'Big Show', :coordinator => coordinator, :venue => venue })
    shows << Factory.create(:show, { :description => 'Little Show', :coordinator => coordinator, :venue => venue })

    post :search , { :search => 'hair'}
    assigns[:shows].should_not be nil
    assigns[:shows].size.should == 0
    response.should render_template(:success)
  end

  it "when a search term has been specified, it should remain in session until cleared" do
    coordinator = Factory.create(:coordinator)
    venue = Factory.create(:venue)
    shows = []
    shows << Factory.create(:show, { :description => 'Big Show', :coordinator => coordinator, :venue => venue })
    shows << Factory.create(:show, { :description => 'Little Show', :coordinator => coordinator, :venue => venue })

    post :search , { :search => 'big'}
    assigns[:shows].should_not be nil
    assigns[:shows].size.should == 1
    assigns[:shows][0].description.should == 'Big Show'
    response.should render_template(:success)

    # Now, re-view the shows index page; the search term should still be in
    # effect
    get :index
    assigns[:shows].should_not be nil
    assigns[:shows].size.should == 1
    assigns[:shows][0].description.should == 'Big Show'
    response.should render_template(:index)

    # Clear the search term
    post :search , { :search => ''}

    get :index
    assigns[:shows].should_not be nil
    assigns[:shows].size.should == shows.size
    response.should render_template(:index)
  end

  it "returns a new show for the new action" do
    2.times { Factory.create(:venue) }
    3.times { Factory.create(:coordinator) }
    get :new
    show = assigns[:show]
    show.should_not be nil
    show.new_record?.should be true

    venues = assigns[:venues]
    venues.should_not be nil
    venues.size.should be 2

    coordinators = assigns[:coordinators]
    coordinators.should_not be nil
    coordinators.size.should be 3

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

    shows = assigns[:shows]
    shows.should_not be nil
    shows.size.should == 1

    response.should render_template(:success)
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

    response.should render_template(:failure)
  end

  it "should load the appropriate show when asked to edit" do
    venue = Factory.create(:venue)
    coordinator = Factory.create(:coordinator)
    show1 = Factory.create(:show, { :coordinator => coordinator, :venue => venue })

    get :edit, { :id => show1.id }
    show = assigns[:show]
    show.should_not be nil
    show.new_record?.should be false

    venues = assigns[:venues]
    venues.should_not be nil
    venues.size.should be 1

    coordinators = assigns[:coordinators]
    coordinators.should_not be nil
    coordinators.size.should be 1

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

    shows = assigns[:shows]
    shows.should_not be nil
    shows.size.should == 1

    response.should render_template(:success)
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

    response.should render_template(:failure)
  end


end

