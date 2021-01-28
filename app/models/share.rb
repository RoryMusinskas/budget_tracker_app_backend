class Share < ApplicationRecord
  validates_presence_of :description, :symbol, :user_sub
end
