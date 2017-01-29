require 'page-object'
require 'pry'

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

class Shoe
  include PageObject
  attr_reader :brand, :name, :price, :description, :release_month, :image, :form

  def initialize(table_element)
    @brand = table_element[0][1].text
    @name = table_element[1][1].text
    @price = table_element[2][1].text
    @description = table_element[3][1].text
    @release_month = table_element[4][1].text
    @image = table_element[5][0].image_element
    if table_element[6].exists?
      @form = Form.new(table_element[6][0].form_element)
    else
      @form = nil
    end
  end

  def image_present?
    image.visible?
  end

  def description_present?
    !description.empty?
  end

  def price_present?
    !price.empty?
  end
end

class Form
  attr_reader :form_element, :textbox
  def initialize(form_element)
    @form_element = form_element
    if form_element.exists?
      @textbox = form_element.text_field_element
    end
  end

  def present?
    form_element.exists?
  end

  def email=(email_address)
    if present?
      @textbox.value = email_address
    else
      raise "No Form Element Present"
    end
  end

  def email
    if present?
      @textbox.value
    else
      raise "No Form Element Present"
    end
  end

  def submit
    if present?
      form_element.submit
    else
      raise "No Form Element Present"
    end
  end
end