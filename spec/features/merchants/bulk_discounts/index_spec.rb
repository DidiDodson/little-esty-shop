require 'rails_helper'

RSpec.describe "bulk_discounts index" do
  before do
    @merchant = create(:merchant)

    @customer1 = create :customer
    @customer2 = create :customer
    @customer3 = create :customer
    @customer4 = create :customer
    @customer5 = create :customer
    @customer6 = create :customer

    @item = create :item, { merchant_id: @merchant.id }

    @bulk_discount1 = @merchant.bulk_discounts.create!(quantity_threshold: 10, percentage: 15)
    @bulk_discount2 = @merchant.bulk_discounts.create!(quantity_threshold: 12, percentage: 10)

    @invoice1 = create :invoice, { customer_id: @customer1.id, status: 'in progress' }
    @invoice2 = create :invoice, { customer_id: @customer2.id, status: 'in progress' }
    @invoice3 = create :invoice, { customer_id: @customer3.id, status: 'in progress' }
    @invoice4 = create :invoice, { customer_id: @customer4.id, status: 'in progress' }
    @invoice5 = create :invoice, { customer_id: @customer5.id, status: 'completed' }
    @invoice6 = create :invoice, { customer_id: @customer6.id, status: 'cancelled' }

    @transaction1 = create :transaction, { invoice_id: @invoice1.id, result: 'success' }
    @transaction2 = create :transaction, { invoice_id: @invoice2.id, result: 'success' }
    @transaction3 = create :transaction, { invoice_id: @invoice3.id, result: 'success' }
    @transaction4 = create :transaction, { invoice_id: @invoice4.id, result: 'success' }
    @transaction5 = create :transaction, { invoice_id: @invoice5.id, result: 'success' }
    @transaction6 = create :transaction, { invoice_id: @invoice6.id, result: 'failed' }

    @inv_item1 = create :invoice_item, { item_id: @item.id, invoice_id: @invoice1.id}
    @inv_item2 = create :invoice_item, { item_id: @item.id, invoice_id: @invoice2.id}
    @inv_item3 = create :invoice_item, { item_id: @item.id, invoice_id: @invoice3.id}
    @inv_item4 = create :invoice_item, { item_id: @item.id, invoice_id: @invoice4.id}
    @inv_item5 = create :invoice_item, { item_id: @item.id, invoice_id: @invoice5.id}
    @inv_item6 = create :invoice_item, { item_id: @item.id, invoice_id: @invoice6.id}

    visit merchant_bulk_discounts_path(@merchant)
  end

  it ''

end
