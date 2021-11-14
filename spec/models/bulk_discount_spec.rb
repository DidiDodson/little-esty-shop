require 'rails_helper'

RSpec.describe BulkDiscount, type: :model do
  describe 'relationships' do
    it { should belong_to(:merchant) }
  end

  describe 'validations' do
    it { should validate_presence_of(:quantity_threshold) }
    it { should validate_presence_of(:percentage) }
    it { should validate_presence_of(:merchant_id) }
  end

  describe 'model methods' do
    before do
      @merchant = create(:merchant)

      @discount1 = @merchant.bulk_discounts.create!(quantity_threshold: 5, percentage: 15)
      @discount2 = @merchant.bulk_discounts.create!(quantity_threshold: 5, percentage: 20)

      @customer6 = create :customer

      @item = create :item, { merchant_id: @merchant.id }
      @item2 = create :item, { merchant_id: @merchant.id }
      @item3 = create :item, { merchant_id: @merchant.id }

      @invoice7 = create :invoice, { customer_id: @customer6.id, status: 'in progress' }

      @transaction7 = create :transaction, { invoice_id: @invoice7.id, result: 'success' }


      @inv_item10 = create :invoice_item, { item_id: @item.id, invoice_id: @invoice7.id, unit_price: 100, quantity: 6 }
      @inv_item11 = create :invoice_item, { item_id: @item2.id, invoice_id: @invoice7.id, unit_price: 100, quantity: 10 }
      @inv_item12 = create :invoice_item, { item_id: @item3.id, invoice_id: @invoice7.id, unit_price: 100, quantity: 1 }
    end

    it 'gives the best_discount for a merchant' do
      expect(@merchant.bulk_discounts.best_discount).to eq([@discount2])
    end
  end
end
