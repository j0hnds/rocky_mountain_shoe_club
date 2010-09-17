require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe AssociateLine do
  before(:each) do
    exhibitor = Factory.create(:exhibitor)
    venue = Factory.create(:venue)
    coordinator = Factory.create(:coordinator)
    show = Factory.create(:show, :venue => venue, :coordinator => coordinator)
    @exhibitor_registration = Factory.create(:exhibitor_registration, 
                                             :show => show, 
                                             :exhibitor => exhibitor)
    @exhibitor_associate = Factory.create(:exhibitor_associate,
                                          :exhibitor_registration => @exhibitor_registration)
    @associate_line = AssociateLine.new
  end

  it "should allow valid values to be set" do
    @associate_line.exhibitor_associate_id = @exhibitor_associate.id
    @associate_line.line = 'a line'
    @associate_line.priority = 1

    @associate_line.valid?.should be true
  end

  it "should ensure that all required fields have been specified" do
    @associate_line.valid?.should be false
    @associate_line.errors.count.should be 3
    @associate_line.errors[:exhibitor_associate_id].blank?.should_not be true
    @associate_line.errors[:line].blank?.should_not be true
    @associate_line.errors[:priority].blank?.should_not be true
  end

  it "should ensure that the lengths of all the fields are valid" do
    @associate_line.exhibitor_associate_id = @exhibitor_associate.id
    @associate_line.line = '012345678901234567890123456789012345678901234567890123456789012345678901234567890'
    @associate_line.priority = 1

    @associate_line.valid?.should be false
    @associate_line.errors.count.should be 1
    @associate_line.errors[:line].blank?.should_not be true
  end

end
