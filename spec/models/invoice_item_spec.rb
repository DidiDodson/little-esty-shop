require 'rails_helper'

RSpec.describe InvoiceItem, type: :model do
  describe 'relationships' do
    it { should belong_to(:item) }
    it { should belong_to(:invoice) }
    it { should have_one(:merchant).through(:item) }
    it { should have_many(:customers).through(:invoice) }
    it { should have_many(:transactions).through(:invoice) }
    it { should have_many(:bulk_discounts).through(:item) }
  end

  describe 'validations' do
    it { should validate_presence_of(:item_id) }
    it { should validate_presence_of(:invoice_id) }
    it { should validate_presence_of(:quantity) }
    it { should validate_presence_of(:unit_price) }
    it { should validate_presence_of(:status) }
  end

  describe 'model methods' do
    before do
      @merchant = create(:merchant)

      @customer1 = create :customer
      @customer2 = create :customer
      @customer3 = create :customer
      @customer4 = create :customer
      @customer5 = create :customer
      @customer6 = create :customer

      @item = create :item, { merchant_id: @merchant.id }

      @discount1 = @merchant.bulk_discounts.create!(quantity_threshold: 5, percentage: 15)
      @discount2 = @merchant.bulk_discounts.create!(quantity_threshold: 5, percentage: 20)

      @invoice1 = create :invoice, { customer_id: @customer1.id, status: 'in progress' }
      @invoice2 = create :invoice, { customer_id: @customer2.id, status: 'in progress' }
      @invoice3 = create :invoice, { customer_id: @customer3.id, status: 'in progress' }
      @invoice4 = create :invoice, { customer_id: @customer4.id, status: 'in progress' }
      @invoice5 = create :invoice, { customer_id: @customer5.id, status: 'cancelled' }
      @invoice6 = create :invoice, { customer_id: @customer6.id, status: 'completed' }

      @transaction1 = create :transaction, { invoice_id: @invoice1.id, result: 'success' }
      @transaction2 = create :transaction, { invoice_id: @invoice2.id, result: 'success' }
      @transaction3 = create :transaction, { invoice_id: @invoice3.id, result: 'success' }
      @transaction4 = create :transaction, { invoice_id: @invoice4.id, result: 'success' }
      @transaction5 = create :transaction, { invoice_id: @invoice5.id, result: 'success' }
      @transaction6 = create :transaction, { invoice_id: @invoice6.id, result: 'failed' }

      @inv_item1 = create :invoice_item, { item_id: @item.id, invoice_id: @invoice1.id, status: "pending"}
      @inv_item2 = create :invoice_item, { item_id: @item.id, invoice_id: @invoice2.id, status: "pending"}
      @inv_item3 = create :invoice_item, { item_id: @item.id, invoice_id: @invoice3.id, status: "pending"}
      @inv_item4 = create :invoice_item, { item_id: @item.id, invoice_id: @invoice4.id, status: "packaged"}
      @inv_item5 = create :invoice_item, { item_id: @item.id, invoice_id: @invoice5.id, status: "packaged"}
      @inv_item6 = create :invoice_item, { item_id: @item.id, invoice_id: @invoice6.id, status: "shipped"}
      @inv_item7 = create :invoice_item, { item_id: @item.id, invoice_id: @invoice1.id, status: "pending", quantity: 6 }
      @inv_item8 = create :invoice_item, { item_id: @item.id, invoice_id: @invoice1.id, status: "pending", quantity: 4 }
    end

    it 'returns incomplete invoices' do
      expect(InvoiceItem.incomplete_inv).to eq([@inv_item1, @inv_item2, @inv_item3, @inv_item4, @inv_item5, @inv_item7, @inv_item8])
    end

    it 'identified an applied merchant inv discount' do
      expect(@inv_item7.discount_applied).to eq(@discount2)
      expect(@inv_item8.discount_applied).to eq(nil)
    end

    it 'identified an applied admin inv discount' do
      expect(@inv_item7.inv_discount_applied).to eq(@discount2)
      expect(@inv_item8.inv_discount_applied).to eq(nil)
    end
  end

  describe 'methods to apply discounts' do
    before do
      @merchant = create(:merchant)
      @merchant2 = create(:merchant)
      @customer1 = create :customer
      @item = create :item, { merchant_id: @merchant.id }

      @discount1 = @merchant.bulk_discounts.create!(quantity_threshold: 5, percentage: 10)
      @discount2 = @merchant.bulk_discounts.create!(quantity_threshold: 5, percentage: 20)
      @discount3 = @merchant.bulk_discounts.create!(quantity_threshold: 7, percentage: 25)
      @discount4 = @merchant.bulk_discounts.create!(quantity_threshold: 3, percentage: 15)
      @discount5 = @merchant2.bulk_discounts.create!(quantity_threshold: 3, percentage: 15)

      @invoice1 = create :invoice, { customer_id: @customer1.id, status: 'in progress' }

      @transaction1 = create :transaction, { invoice_id: @invoice1.id, result: 'success' }

      @inv_item7 = create :invoice_item, { item_id: @item.id, invoice_id: @invoice1.id, status: "pending", quantity: 6}
      @inv_item8 = create :invoice_item, { item_id: @item.id, invoice_id: @invoice1.id, status: "pending", quantity: 4}
      @inv_item9 = create :invoice_item, { item_id: @item.id, invoice_id: @invoice1.id, status: "pending", quantity: 8}
    end

    it 'applies discounts to merchant invoices' do
      inv_item_7_result = (("#{@inv_item7.quantity}").to_f * ("#{@inv_item7.unit_price}").to_f * ("#{@discount2.percentage}").to_f.fdiv(10000)).round

      inv_item_8_result = (("#{@inv_item8.quantity}").to_f * ("#{@inv_item8.unit_price}").to_f * ("#{@discount4.percentage}").to_f.fdiv(10000)).round

      expect(@inv_item7.items_disc.round).to eq(inv_item_7_result)
      expect(@inv_item8.items_disc.round).to eq(inv_item_8_result)
    end

    it 'applies disocunts to admin invoices' do
      inv_item_7_result = (("#{@inv_item7.quantity}").to_f * ("#{@inv_item7.unit_price}").to_f * ("#{@discount2.percentage}").to_f.fdiv(10000)).round

      inv_item_8_result = (("#{@inv_item8.quantity}").to_f * ("#{@inv_item8.unit_price}").to_f * ("#{@discount4.percentage}").to_f.fdiv(10000)).round

      expect(@inv_item7.admin_items_disc.round).to eq(inv_item_7_result)
      expect(@inv_item8.admin_items_disc.round).to eq(inv_item_8_result)
    end
  end
end
