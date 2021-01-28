class AddSubToIncomes < ActiveRecord::Migration[6.0]
  def change
    add_column :incomes, :user_sub, :string, null: false
  end
end
