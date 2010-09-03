# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def format_address(addr_object)
    addr = addr_object.address_1
    addr << "<br>#{addr_object.address_2}" unless addr_object.address_2.blank?
    addr << "<br>#{addr_object.city}, #{addr_object.state} #{addr_object.postal_code}"
  end

  def format_date(date)
    date.strftime("%Y-%m-%d") if date
  end

  def state_postal_codes
    %w{ AL AK AZ AR CA CO CT DE DC FL GA HI ID IL IN IA KS KY LA ME MD MA MI MN MS MO MT NE NV NH NJ NM NY NC ND OH OK OR PA RI SC SD TN TX UT VT VA WA WV WI WY }
  end
end
