class InvoiceItem < ApplicationRecord
  belongs_to :item
  belongs_to :invoice
  has_one :merchant, through: :item
  has_many :customers, through: :invoice
  has_many :transactions, through: :invoice
  has_many :bulk_discounts, through: :item

  validates_presence_of :item_id
  validates_presence_of :invoice_id
  validates_presence_of :quantity
  validates_presence_of :unit_price
  validates_presence_of :status

  def self.incomplete_inv
    self.where(status: ['pending', 'packaged'])
  end

  def discount_applied
    merchant.bulk_discounts
      .where('quantity_threshold <= ?', quantity)
      .order(percentage: :desc)
      .limit(1)
      .first
  end

  def inv_discount_applied
    bulk_discounts
      .where('quantity_threshold <= ?', quantity)
      .order(percentage: :desc)
      .limit(1)
      .first
  end 

  def items_disc
    merch_discounts = merchant.bulk_discounts.where('quantity_threshold <= ?', quantity)

    discounts = merch_discounts.map do |merch_dis|
      merch_dis.percentage
    end
    max_discount = discounts.max

    ((max_discount.to_f * self.unit_price.to_f * self.quantity.to_f) / 10000)
  end

  def admin_items_disc
    admin_discounts = bulk_discounts.where('quantity_threshold <= ?', quantity)

    discounts = admin_discounts.map do |admin_dis|
      admin_dis.percentage
    end
    max_discount = discounts.max

    ((max_discount.to_f * self.unit_price.to_f * self.quantity.to_f) / 10000)
  end
end
