# this is added so you dont have to add 'FactoryBot' to each FactoryBot method with rspec
RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods
end
