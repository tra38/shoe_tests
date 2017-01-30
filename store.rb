require 'page-object'
require_relative 'shoe'
require_relative 'form'

class Store
  include PageObject

  page_url("https://shoestore-manheim.rhcloud.com")

  def see_all_shoes
    @browser.goto("https://shoestore-manheim.rhcloud.com/shoes")
  end

  ["January", "February",  "March",  "April", "May", "June", "July", "August", "September", "October", "November", "December"].each do |month|
    link(:"view_#{month.downcase}_shoes", {:href => "/months/#{month.downcase}" })
  end

  link(:view_all_shoes, { :href => "/shoes" })

  link(:view_home_page, {:href => "/" })

  def shoes
    shoe_tables.map do |table|
      Shoe.new(table.table_elements[0])
    end
  end

  ul(:shoe_list, { id: "shoe_list" })

  def shoe_tables
    self.shoe_list_element.list_item_elements
  end

  form(:notification_form, { :class => "notification_email_form" })
  form(:remind_form, { :id => "remind_email_form" })

  def notification_form
    Form.new(notification_form_element)
  end

  def remind_form
    Form.new(remind_form_element)
  end

  div(:flash, { :id => "flash"})
  def flash_text
    flash_element.text
  end

end