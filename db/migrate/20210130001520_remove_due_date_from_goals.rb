class RemoveDueDateFromGoals < ActiveRecord::Migration[6.0]
  def change
    remove_column :goals, :due_date
  end
end
