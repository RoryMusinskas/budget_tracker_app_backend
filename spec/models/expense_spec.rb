require 'rails_helper'

RSpec.describe 'Expense Model', type: :model do
  before(:all) do
    @expense = create(:expense)
  end
  it 'is valid with valid attributes' do
    expect(@expense).to be_valid
  end
  
  it 'is not valid without a title' do
    expense = Expense.new(title: nil)
    expect(expense).to_not be_valid
  end
  
  it 'is not valid without a description' do
    expense = Expense.new(description: nil)
    expect(expense).to_not be_valid
  end

  it 'is not valid without an amount' do
    expense = Expense.new(amount: nil)
    expect(expense).to_not be_valid
  end
  
  it 'is not valid without a category' do
    expense = Expense.new(category_id: nil)
    expect(expense).to_not be_valid
  end
  
  it 'is not valid without a user sub' do
    expense = Expense.new(user_sub: nil)
    expect(expense).to_not be_valid
  end

  it 'is not valid without a date' do
    expense = Expense.new(date: nil)
    expect(expense).to_not be_valid
  end
end