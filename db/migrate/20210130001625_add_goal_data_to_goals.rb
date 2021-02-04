class AddGoalDataToGoals < ActiveRecord::Migration[6.0]
  def change
    add_column :goals, :goals_data, :json, default: {} 
  end
end
