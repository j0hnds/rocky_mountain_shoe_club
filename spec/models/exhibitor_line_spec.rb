require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ExhibitorLine do
  before(:each) do
    exhibitor = Factory.create(:exhibitor)
    venue = Factory.create(:venue)
    coordinator = Factory.create(:coordinator)
    show = Factory.create(:show, :venue => venue, :coordinator => coordinator)
    @exhibitor_registration = Factory.create(:exhibitor_registration, 
                                             :show => show, 
                                             :exhibitor => exhibitor)
    @exhibitor_line = ExhibitorLine.new
  end

  it "should allow valid values to be set" do
    @exhibitor_line.exhibitor_registration_id = @exhibitor_registration.id
    @exhibitor_line.line = 'the line'
    @exhibitor_line.priority = 1

    @exhibitor_line.valid?.should be true
  end

  it "should ensure that all required fields have been specified" do
    @exhibitor_line.valid?.should be false
    @exhibitor_line.errors.count.should be 3
    @exhibitor_line.errors[:exhibitor_registration_id].blank?.should_not be true
    @exhibitor_line.errors[:line].blank?.should_not be true
    @exhibitor_line.errors[:priority].blank?.should_not be true
  end

  it "should ensure that the lengths of all the fields are valid" do
    @exhibitor_line.exhibitor_registration_id = @exhibitor_registration.id
    @exhibitor_line.line = '012345678901234567890123456789012345678901234567890123456789012345678901234567890'
    @exhibitor_line.priority = 1

    @exhibitor_line.valid?.should be false
    @exhibitor_line.errors.count.should be 1
    @exhibitor_line.errors[:line].blank?.should_not be true
  end

end
