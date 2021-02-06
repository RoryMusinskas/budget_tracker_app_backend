class AddDefaultValuesToGoalsData < ActiveRecord::Migration[6.0]
  def up
    change_column :goals, :goals_data, :json, default: {
      "goals": {
      },
      "columns": {
        "column-1": {
          "id": "column-1",
          "title": "Goals",
          "goalIds": []
        },
        "column-2": {
          "id": "column-2",
          "title": "In progress",
          "goalIds": []
        },
        "column-3": {
          "id": "column-3",
          "title": "Completed",
          "goalIds": []
        }
      },
      "columnOrder": ["column-1", "column-2", "column-3"]
    }
  end
  def down
    change_column :goals, :goals_data, :json, default: {} 
  end
end
