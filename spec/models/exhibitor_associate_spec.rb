require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ExhibitorAssociate do

  before(:each) do
    exhibitor = Factory.create(:exhibitor)
    venue = Factory.create(:venue)
    coordinator = Factory.create(:coordinator)
    show = Factory.create(:show, :venue => venue, :coordinator => coordinator)
    @exhibitor_registration = Factory.create(:exhibitor_registration,
                                             :show => show,
                                             :exhibitor => exhibitor)
    @exhibitor_associate = ExhibitorAssociate.new
  end

  it "should allow valid values to be set" do
    @exhibitor_associate.exhibitor_registration_id = @exhibitor_registration.id
    @exhibitor_associate.first_name = 'John'
    @exhibitor_associate.last_name = 'Son'
    @exhibitor_associate.room = '101'

    @exhibitor_associate.valid?.should be true
  end

  it "should ensure that all required fields have been specified" do
    @exhibitor_associate.valid?.should be false
    @exhibitor_associate.errors.count.should be 3
    @exhibitor_associate.errors[:exhibitor_registration_id].blank?.should_not be true
    @exhibitor_associate.errors[:first_name].blank?.should_not be true
    @exhibitor_associate.errors[:last_name].blank?.should_not be true
  end

  it "should ensure that the lengths of all the fields are valid" do
    @exhibitor_associate.exhibitor_registration_id = @exhibitor_registration.id
    @exhibitor_associate.first_name = '01234567890123456789012345678901234567890'
    @exhibitor_associate.last_name = '01234567890123456789012345678901234567890'
    @exhibitor_associate.room = '01234567890'
    
    @exhibitor_associate.valid?.should be false
    @exhibitor_associate.errors.count.should be 3
    @exhibitor_associate.errors[:first_name].blank?.should_not be true
    @exhibitor_associate.errors[:last_name].blank?.should_not be true
    @exhibitor_associate.errors[:room].blank?.should_not be true
  end

end
