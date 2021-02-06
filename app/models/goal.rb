class Goal < ApplicationRecord
  validates_presence_of :goals_data, :user_sub
end
