Rails.application.routes.draw do
  resources :shares
  resources :goals
  resources :incomes
  resources :expenses
  resources :categories
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
