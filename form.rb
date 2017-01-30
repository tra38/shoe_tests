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