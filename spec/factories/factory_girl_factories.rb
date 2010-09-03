
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