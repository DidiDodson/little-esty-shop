class BulkDiscount < ApplicationRecord
  belongs_to :merchant
  scope :best_discount, -> { order('percentage desc').limit(1) }

  validates_presence_of :quantity_threshold
  validates_presence_of :percentage
  validates_presence_of :merchant_id
end
