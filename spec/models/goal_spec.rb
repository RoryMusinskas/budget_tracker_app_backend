require 'rails_helper'

RSpec.describe 'Goal Model', type: :model do
  before(:all) do
    @goal = create(:goal)
  end
  
  it 'is valid with valid attributes' do
   expect(@goal).to be_valid
  end
  
  it 'is not valid with no user sub' do
    goal = Goal.create(user_sub: nil)
    expect(goal).to_not be_valid
  end

  it 'is not valid with no goal data hash' do
    goal = Goal.create(goals_data: nil)
    expect(goal).to_not be_valid
  end
end