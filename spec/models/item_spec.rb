require 'rails_helper'

RSpec.describe Item, type: :model do
  describe 'relationships' do
    it { should belong_to(:merchant) }
    it { should have_many(:invoice_items) }
    it { should have_many(:invoices).through(:invoice_items) }
    it { should have_many(:bulk_discounts).through(:merchant) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:description) }
    it { should validate_presence_of(:unit_price) }
    it { should validate_presence_of(:status) }
    it { should validate_presence_of(:merchant_id) }
  end

  describe 'class methods' do
    before(:each) do
      @merchant = create(:merchant)
      @item1 = create :item, { merchant_id: @merchant.id, status: 'enabled' }
      @item2 = create :item, { merchant_id: @merchant.id }
    end
    describe '.item_status' do
      it 'returns recrods where the status equals the argument' do
        expect(Item.item_status('enabled')).to eq([@item1])
        expect(Item.item_status('disabled')).to eq([@item2])
      end
    end
  end
end
