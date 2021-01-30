class ChangeExpensesUserIdToSub < ActiveRecord::Migration[6.0]
  def change
    remove_column :expenses, :user_id
  end
end
