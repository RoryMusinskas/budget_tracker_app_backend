class AddTitleAndDateToIncome < ActiveRecord::Migration[6.0]
  def change
    add_column :incomes, :title, :string
    add_column :incomes, :date, :date
  end
end
