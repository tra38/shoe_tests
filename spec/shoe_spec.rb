require "spec_helper"
require "date"
require_relative "../store"

def visit_homepage
  @store = Store.new(@browser)
  @store.goto
end

describe "Store " do
  ["January", "February",  "March",  "April", "May", "June", "July", "August", "September", "October", "November", "December"].each do |month|

    describe "#{month} tests" do
      before(:all) do
        visit_homepage
        @store.send(:"view_#{month.downcase}_shoes")
        @month_shoes = @store.shoes
      end

      it "expects each shoe to display an image" do
        @month_shoes.each do |shoe|
          expect(shoe.image_present?).to eq(true)
        end
      end

      it "expects each shoe to display a description" do
        @month_shoes.each do |shoe|
          expect(shoe.description_present?).to eq(true)
        end
      end

      it "expects each shoe to display a price" do
        @month_shoes.each do |shoe|
          expect(shoe.price_present?).to eq(true)
        end
      end
    end
  end

  describe "sign up for emails on upcoming releases for shoes and receive a confirmation message" do
    before do
      visit_homepage
      @remind_form = @store.remind_form
    end

    ["bob@example.com", "<script>alert('XSS')</script>", "not really an email", "email.with.periods+and+symbols@example.com", %{"quotation marks"@example.com}].each do |string|
      it "submits the email '#{string}' " do
        @remind_form.email = "#{string}"
        @remind_form.submit
        expect(@store.flash_text).to eq("Thanks! We will notify you of our new shoes at this email: #{string}")
      end
    end
  end

end


# BUGS DISCOVEERD - no images present on November page, <script>alert('XSS')</script> causes an 'internal service error'