Then /^I see the following links in the navigation bar:$/ do |table|
  table.hashes.each_with_index do | hash, index |
    link_name = hash['link_name']
    within "div#navbar > div > ul > li:nth-child(#{index + 1})" do | scope |
      scope.should contain(link_name)
    end
  end
end
