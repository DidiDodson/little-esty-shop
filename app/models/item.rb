class Item < ApplicationRecord
  belongs_to :merchant
  has_many :invoice_items, dependent: :destroy
  has_many :invoices, through: :invoice_items
  has_many :bulk_discounts, through: :merchant

  validates_presence_of :name
  validates_presence_of :description
  validates_presence_of :unit_price
  validates_presence_of :status
  validates_presence_of :merchant_id

  def self.item_status(status)
    where(status: status)
  end

  def item_best_day
    invoices.joins(:invoice_items)
            .select('invoices.created_at, invoice_items.quantity')
            .order('invoice_items.quantity desc')
            .first
            .created_at
            .to_date
  end
end
