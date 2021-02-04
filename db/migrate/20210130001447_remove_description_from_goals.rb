class RemoveDescriptionFromGoals < ActiveRecord::Migration[6.0]
  def change
    remove_column :goals, :description
  end
end
