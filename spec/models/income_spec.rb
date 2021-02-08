require 'rails_helper'

RSpec.describe 'Income Model', type: :model do
  before(:all) do
    @income = create(:income)
  end
  it 'is valid with valid attributes' do
    expect(@income).to be_valid
  end
  
  it 'is not valid without a title' do
    income = Income.new(title: nil)
    expect(income).to_not be_valid
  end
  
  it 'is not valid without a description' do
    income = Income.new(description: nil)
    expect(income).to_not be_valid
  end

  it 'is not valid without an amount' do
    income = Income.new(amount: nil)
    expect(income).to_not be_valid
  end
  
  it 'is not valid without a category' do
    income = Income.new(category_id: nil)
    expect(income).to_not be_valid
  end
  
  it 'is not valid without a user sub' do
    income = Income.new(user_sub: nil)
    expect(income).to_not be_valid
  end

  it 'is not valid without a date' do
    income = Income.new(date: nil)
    expect(income).to_not be_valid
  end
end