Given /^a clean database$/ do
  DatabaseCleaner.clean
end

Given /^a show$/ do
  venue = Factory.create(:venue)
  coordinator = Factory.create(:coordinator)
  Factory.create(:show, :venue => venue, :coordinator => coordinator)
end
