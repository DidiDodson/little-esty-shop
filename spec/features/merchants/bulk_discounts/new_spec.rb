require 'rails_helper'

RSpec.describe 'the new bulk_discount form page' do
  before(:each) do
    @merchant = create(:merchant)

    visit new_merchant_bulk_discount_path(@merchant)
  end

  it 'can create a new bulk_discount' do
    fill_in "bulk_discount_quantity_threshold", with: 200
    fill_in "bulk_discount_percentage", with: 30

    click_button "Create Bulk discount"

    expect(current_path).to eq(merchant_bulk_discounts_path(@merchant))
    expect(page).to have_content("Quantity Threshold: 200")
  end
end
