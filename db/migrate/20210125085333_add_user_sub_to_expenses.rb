class AddUserSubToExpenses < ActiveRecord::Migration[6.0]
  def change
    add_column :expenses, :user_sub, :string
  end
end
