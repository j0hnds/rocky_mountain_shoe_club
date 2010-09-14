require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe BuyerRegistration do
  before(:each) do
    @coordinator = Factory.create(:coordinator)
    @venue = Factory.create(:venue)
    @shows = []
    3.times { @shows << Factory.create(:show, :coordinator => @coordinator, :venue => @venue) }
    @store = Factory.create(:store)
    @buyers = []
    3.times { @buyers << Factory.create(:buyer, :store => @store) }
  end

  it "should link the association between a show and a buyer" do
    @shows.each do | show |
      @buyers.each do | buyer |
        br = BuyerRegistration.new(:show => show, :buyer => buyer)
        br.save.should be true
      end
    end

    registrations = BuyerRegistration.all
    registrations.count.should be 9

    # Now, verify that the associations have been made
    registrations.each do | br |
      # Make sure each registration can access a show and a buyer
      br.show.should_not be nil
      br.buyer.should_not be nil
    end

    shows = Show.all
    shows.count.should be 3

    # Now, for each show, we should be able to see the registrations and
    # the buyers
    shows.each do | show |
      registrations = show.buyer_registrations
      registrations.should_not be nil
      registrations.count.should be 3

      buyers = show.buyers
      buyers.should_not be nil
      buyers.count.should be 3
    end

    buyers = Buyer.all
    buyers.count.should be 3

    # Now, for each buyer, we should be able to see the registrations and
    # the shows
    buyers.each do | buyer |
      registrations = buyer.buyer_registrations
      registrations.should_not be nil
      registrations.count.should be 3

      shows = buyer.shows
      shows.should_not be nil
      shows.count.should be 3
    end
  end
end
