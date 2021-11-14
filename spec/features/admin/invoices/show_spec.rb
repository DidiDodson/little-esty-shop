require 'rails_helper'

RSpec.describe "admin invoice show" do
  before do
    @merchant = create(:merchant)

    @customer3 = create :customer

    @item7 = create :item, { merchant_id: @merchant.id }
    @item8 = create :item, { merchant_id: @merchant.id }
    @item9 = create :item, { merchant_id: @merchant.id }

    @bulk_discount1 = @merchant.bulk_discounts.create!(quantity_threshold: 6, percentage: 15)
    @bulk_discount2 = @merchant.bulk_discounts.create!(quantity_threshold: 5, percentage: 20)

    @invoice8 = create :invoice, { customer_id: @customer3.id, created_at: DateTime.new(2021, 1, 5) }

    @inv_item11 = create :invoice_item, { item_id: @item7.id, invoice_id: @invoice8.id, unit_price: 10000, quantity: 4, status: "pending" }
    @inv_item12 = create :invoice_item, { item_id: @item8.id, invoice_id: @invoice8.id, unit_price: 3000, quantity: 6, status: "shipped"}
    @inv_item13 = create :invoice_item, { item_id: @item9.id, invoice_id: @invoice8.id, unit_price: 3000, quantity: 7, status: "shipped"}


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
      expect(page).to have_content(@inv_item11.unit_price / 100)
      expect(page).to have_content(@inv_item11.status)
      expect(page).to_not have_content(@inv_item12.quantity)
    end
  end

  it 'gives dropdown menu option for invoice item status' do
    within("#item-#{@item7.id}") do
      expect(find_field(:invoice_item_status).value).to eq("pending")

      expect(page).to have_button("Update Invoice Status")
      select "shipped", from: 'invoice_item_status'
      click_button "Update Invoice Status"

      expect(current_path).to eq(admin_invoice_path(@invoice8.id))

      expect(find_field(:invoice_item_status).value).to eq("shipped")
    end
  end

  it 'shows invoice total revenue minus discounts' do
    expect(page).to have_content("Invoice total revenue after discounts")
  end

  it 'shows link to view applied discounts' do
    within("#item-#{@item9.id}") do
      expect(page).to have_link("View Discount")
      click_link "View Discount"

      expect(current_path).to eq(admin_bulk_discount_path(@bulk_discount2))
    end
  end
end
