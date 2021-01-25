class Expense < ApplicationRecord
  belongs_to :category
  
  validates_presence_of :description, :amount, :category_id
end
