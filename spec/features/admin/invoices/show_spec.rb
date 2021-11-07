require 'rails_helper'

RSpec.describe "admin invoice show" do
  before do
    @merchant = create(:merchant)

    @customer3 = create :customer

    @item7 = create :item, { merchant_id: @merchant.id }
    @item8 = create :item, { merchant_id: @merchant.id }

    @invoice8 = create :invoice, { customer_id: @customer3.id, created_at: DateTime.new(2021, 1, 5) }

    @inv_item11 = create :invoice_item, { item_id: @item7.id, invoice_id: @invoice8.id, unit_price: 10000, quantity: 4 }
    @inv_item12 = create :invoice_item, { item_id: @item8.id, invoice_id: @invoice8.id, unit_price: 3000, quantity: 6 }

    visit admin_invoice_path(@invoice8.id)
  end

  it 'shows invoice info' do
    expect(page).to have_content(@invoice8.id)
    expect(page).to have_content(@invoice8.status)
    expect(page).to have_content(@invoice8.created_at.strftime('%A, %B%e, %Y'))
    expect(page).to have_content(@invoice8.customer.full_name)
  end

  it 'shows invoice item info' do
    expect(page).to have_content(@item7.name)
    expect(page).to have_content(@item8.name)

    within("#item-#{@item7.id}") do
      expect(page).to have_content(@item7.name)
      expect(page).to have_content(@inv_item11.quantity)
      expect(page).to have_content(@inv_item11.unit_price)
      expect(page).to have_content(@inv_item11.status)
      expect(page).to_not have_content(@inv_item12.status)
    end
  end
end