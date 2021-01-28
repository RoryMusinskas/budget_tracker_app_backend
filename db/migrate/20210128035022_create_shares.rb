class CreateShares < ActiveRecord::Migration[6.0]
  def change
    create_table :shares do |t|
      t.string :description
      t.string :symbol
      t.string :user_sub, null: false

      t.timestamps
    end
  end
end
