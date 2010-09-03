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
end
