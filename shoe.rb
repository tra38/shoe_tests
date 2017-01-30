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
