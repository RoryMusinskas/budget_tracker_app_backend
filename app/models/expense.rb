class Expense < ApplicationRecord
  belongs_to :user
  belongs_to :category
  
  validates_presence_of :description, :amount, :user_id, :category_id
end
