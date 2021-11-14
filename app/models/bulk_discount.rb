class BulkDiscount < ApplicationRecord
  belongs_to :merchant

  validates_presence_of :quantity_threshold
  validates_presence_of :percentage
  validates_presence_of :merchant_id
end
