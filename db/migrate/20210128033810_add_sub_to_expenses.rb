class AddSubToExpenses < ActiveRecord::Migration[6.0]
  def change
    add_column :expenses, :user_sub, :string, null: false
  end
end
