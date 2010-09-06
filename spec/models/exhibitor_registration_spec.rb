# To change this template, choose Tools | Templates
# and open the template in the editor.

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ExhibitorRegistration do
  before(:each) do
#    @exhibitor_registration = ExhibitorRegistration.new
    @coordinator = Factory.create(:coordinator)
    @venue = Factory.create(:venue)
    @shows = []
    @exhibitors = []
    3.times { @shows << Factory.create(:show, :coordinator => @coordinator, :venue => @venue) }
    3.times { @exhibitors << Factory.create(:exhibitor) }
  end

  it "should link the association between a show and exhibitor" do
    # Register 3 exhibitors with each of three shows
    @shows.each do | show |
      @exhibitors.each do | exhibitor |
        er = ExhibitorRegistration.new(:show => show, :exhibitor => exhibitor)
        er.save.should be true
      end
    end

    registrations = ExhibitorRegistration.all
    registrations.count.should be 9

    # Now, verify that the associations have been made
    registrations.each do | er |
      # Make sure each registration can access a show and an exhibitor
      er.show.should_not be nil
      er.exhibitor.should_not be nil
      er.room.should be nil
    end

    shows = Show.all
    shows.count.should be 3

    # Now, for each show, we should be able to see the registrations and the
    # exhibitors
    shows.each do | show |
      registrations = show.exhibitor_registrations
      registrations.should_not be nil
      registrations.count.should be 3

      exhibitors = show.exhibitors
      exhibitors.should_not be nil
      exhibitors.count.should be 3
    end

    exhibitors = Exhibitor.all
    exhibitors.count.should be 3

    # Now, for each exhibitor, we should be able to see the registrations and
    # the shows
    exhibitors.each do | exhibitor |
      registrations = exhibitor.exhibitor_registrations
      registrations.should_not be nil
      registrations.count.should be 3

      shows = exhibitor.shows
      shows.should_not be nil
      shows.count.should be 3
    end
  end
end

