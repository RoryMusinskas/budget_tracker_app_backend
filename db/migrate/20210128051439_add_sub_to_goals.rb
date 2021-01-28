class AddSubToGoals < ActiveRecord::Migration[6.0]
  def change
    add_column :goals, :user_sub, :string, null: false
  end
end
