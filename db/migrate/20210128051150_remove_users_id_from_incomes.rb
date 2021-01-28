class RemoveUsersIdFromIncomes < ActiveRecord::Migration[6.0]
  def change
  remove_column :incomes, :user_id, null: false
  end
end
