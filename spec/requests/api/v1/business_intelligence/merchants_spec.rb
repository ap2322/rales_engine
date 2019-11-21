require 'rails_helper'
require 'rake'

describe "Merchant's business intelligence API" do

  it "returns the top x merchants ranked by revenue" do
    create(:merchant, :with_invoices)
    binding.pry
  end
end
