require 'rails_helper'

RSpec.describe 'the bulk_discount show page' do
  before(:each) do
    @merchant = create(:merchant)
    @discount = @merchant.bulk_discounts.create!(quantity_threshold: 10, percentage: 15)

    visit merchant_bulk_discount_path(@merchant, @discount)
  end

  it 'show a bulk_discounts quantity_threshold and percentage' do
    expect(current_path).to eq(merchant_bulk_discount_path(@merchant, @discount))

    expect(page).to have_content("Quantity Threshold: 10")
    expect(page).to have_content("Percentage: 15%")
  end
end
