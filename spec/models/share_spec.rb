require 'rails_helper'

RSpec.describe 'Share Model', type: :model do
  before(:all) do
    @share = create(:share)
  end
  
  it 'is valid with valid attributes' do
   expect(@share).to be_valid
  end
  
  it 'is not valid with no description' do
    share = Share.create(description: nil)
    expect(share).to_not be_valid
  end
  
  it 'is not valid with no symbol' do
    share = Share.create(symbol: nil)
    expect(share).to_not be_valid
  end
  
  it 'is not valid with no user sub' do
    share = Share.create(user_sub: nil)
    expect(share).to_not be_valid
  end
end
