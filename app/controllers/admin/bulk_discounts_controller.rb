class Admin::BulkDiscountsController < ApplicationController
  def index
    @bulk_discounts = BulkDiscount.all
  end

  def show
    @bulk_discount = BulkDiscount.find(params[:id])
  end

  private
  def bulk_dis_params
    params.require(:bulk_discount).permit(:quantity_threshold, :percentage)
  end
end
