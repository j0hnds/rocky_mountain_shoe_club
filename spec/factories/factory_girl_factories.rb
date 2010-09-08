
Factory.sequence :name do |n|
  str = ''
  10.times { str << ('a'..'z').to_a[rand(26)] }
  str
end

Factory.define :coordinator do |f|
  first_name = Factory.next :name
  last_name = Factory.next :name
  f.first_name first_name
  f.last_name last_name
  f.phone '333-333-3333'
  f.email "#{first_name}.#{last_name}@email.com"
end

Factory.define :exhibitor do |f|
  first_name = Factory.next :name
  last_name = Factory.next :name
  f.first_name first_name
  f.last_name last_name
  f.address_1 '123 Main Street'
  f.city 'San Francisco'
  f.state 'CA'
  f.postal_code '90911-111'
  f.email "#{first_name}.#{last_name}@mail.com"
end

Factory.define :venue do |f|
  f.name Factory.next :name
  f.address_1 Factory.next :name
  f.city 'San Francisco'
  f.state 'CO'
  f.postal_code '90112'
  f.phone '111-111-1111'
  f.fax '222-222-2222'
  f.reservation '333-333-3333'
end

# Pass in :coordinator and :venue
Factory.define :show do |f|
  f.description Factory.next :name
  f.start_date Date.today
  f.end_date Date.today + 1.day
  f.next_start_date Date.today + 180.days
  f.next_end_date Date.today + 181.days
end

Factory.define :store do |f|
  f.name Factory.next :name
  f.address_1 Factory.next :name
  f.city 'San Francisco'
  f.state 'CA'
  f.postal_code '80111'
end