class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :email
      t.string :shares_preferences, array:true, default: []

      t.timestamps
    end
    add_index :users, :email, unique: true
  end
end
