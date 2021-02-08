require 'rails_helper'

RSpec.describe 'Category Model', type: :model do
  before(:all) do
    @category = create(:category)
  end
  
  it 'is valid with valid attributes' do
    expect(@category).to be_valid
  end
  
  it 'is not valid without a description' do
    category = Category.create(description: nil)
    expect(category).to_not be_valid
  end
end