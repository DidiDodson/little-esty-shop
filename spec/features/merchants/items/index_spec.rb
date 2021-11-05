require 'rails_helper'

RSpec.describe "merchant's item index page" do
  before(:each) do
    @merchant = create(:merchant)
    @merchant2 = create(:merchant)
    @item1 = create :item, { merchant_id: @merchant.id }
    @item2 = create :item, { merchant_id: @merchant.id }
    @item3 = create :item, { merchant_id: @merchant.id, status: 'enabled' }
    @item4 = create :item, { merchant_id: @merchant2.id }

    visit merchant_items_path(@merchant)
  end

  it 'i see a list of names of all items' do
    expect(current_path).to eq(merchant_items_path(@merchant))

    expect(page).to have_content(@item1.name)
    expect(page).to have_content(@item2.name)
    expect(page).to have_content(@item3.name)
    expect(page).not_to have_content(@item4.name)
  end

  it 'has names as links' do
    click_link @item1.name

    expect(current_path).to eq(merchant_item_path(@merchant, @item1))
  end

  it 'has a button next to item to enable/disable' do
    within("#item-#{@item1.id}") do
      click_button 'Enable'
      expect(page).to have_button('Disable')
    end
  end

  it 'sections for enabled and disabled items' do 
    within('#enabled') do 
      expect(page).to have_content(@item3.name)
    end 

    within('#disabled') do 
      save_and_open_page
      expect(page).to have_content(@item1.name)
      expect(page).to have_content(@item2.name)
    end 
  end 
end