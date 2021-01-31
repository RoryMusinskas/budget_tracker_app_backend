class AddNameToExpenses < ActiveRecord::Migration[6.0]
  def change
    add_column :expenses, :title, :string
  end
end
