class Income < ApplicationRecord
  belongs_to :category
  
  validates_presence_of :description, :amount, :category_id, :user_sub, :title, :date
end
