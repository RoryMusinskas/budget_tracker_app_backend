class RemoveUsersTable < ActiveRecord::Migration[6.0]
  def change
    drop_table :users do |t|
      t.string :email
      t.string :shares_preferences, array:true, default: []

      t.timestamps
    end
  end
end
