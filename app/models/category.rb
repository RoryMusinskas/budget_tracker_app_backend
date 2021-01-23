class Category < ApplicationRecord
  validates_presence_of :description, :due_date
end
