class Invoice < ApplicationRecord
  belongs_to :customer
  has_many :transactions
  has_many :invoice_items, dependent: :destroy
  has_many :items, through: :invoice_items
  has_many :bulk_discounts, through: :invoice_items
  has_one :merchant, through: :items

  validates_presence_of :customer_id
  validates_presence_of :status

  def self.in_progress
    where(status: 'in progress')
  end

  def self.order_from_oldest
    order(created_at: :desc)
  end

  def total_item_revenue_by_merchant(merchant_id)
    invoice_items.joins(:item)
                 .where(items: {merchant_id: merchant_id})
                 .sum("invoice_items.unit_price * invoice_items.quantity")
  end

  def total_invoice_revenue(invoice_id)
    invoice_items.joins(:invoice)
                 .where(invoice_items: {invoice_id: invoice_id})
                 .sum("invoice_items.unit_price * invoice_items.quantity")
  end

  def total_discounts(invoice_id, merchant_id)
    invoice_items.sum do |inv_item|
      inv_item.items_disc
    end
  end

  def admin_total_discounts(invoice_id)
    invoice_items.sum do |inv_item|
      inv_item.items_disc
    end
  end
end
