require 'rails_helper'

RSpec.describe 'the bulk_discount edit page' do
  before(:each) do
    @merchant = create(:merchant)
    @discount = @merchant.bulk_discounts.create!(quantity_threshold: 10, percentage: 15)

    visit edit_merchant_bulk_discount_path(@merchant, @discount)
  end

  it 'shows a form to update a discount' do
    expect(page).to have_content("Quantity threshold")
    expect(page).to have_content("Percentage")

    fill_in "bulk_discount_quantity_threshold", with: "15"
    fill_in "bulk_discount_percentage", with: "20"
    click_button "Update"

    expect(current_path).to eq(merchant_bulk_discount_path(@merchant, @discount))
    expect(page).to have_content("Quantity Threshold: 15")
    expect(page).to have_content("Percentage: 20%")
  end
end
