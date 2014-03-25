require 'active_record'
require 'rspec'
require 'shoulda-matchers'
require 'pry'

require 'product'
require 'cashier'



database_configurations = YAML::load(File.open('./db/config.yml'))
development_configuration = database_configurations['test']
ActiveRecord::Base.establish_connection(development_configuration)


RSpec.configure do |config|
  config.after(:each) do
    Product.all.each { |product| product.destroy }
    Cashier.all.each { |cashier| cashier.destroy }
  end
end
