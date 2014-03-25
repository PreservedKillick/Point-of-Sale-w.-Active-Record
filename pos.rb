require 'active_record'
require './lib/product'
require './lib/cashier'
require 'pry'

database_configurations = YAML::load(File.open('./db/config.yml'))
development_configuration = database_configurations['development']
ActiveRecord::Base.establish_connection(development_configuration)

system "clear"
def welcome
  puts "\nAre you a Manager or a Cashier?\n"
  choice = nil
  until choice == 'x'
    puts "\nPress 'm' for Manager, 'c' for Cashier or 'x' to exit the system."
    choice = gets.chomp.downcase
    case choice
    when 'm'
      manager_menu
    when 'c'
      cashier_menu
    when 'x'
      puts "Bye!!\n\n\n"
    else
      puts "Sorry, not a valid option. Try again."
    end
  end
end

###############################################

def manager_menu
  puts "Press 'p' to add/edit a product."
  puts "Press 'c' to add/edit a cashier."
  puts "Press 'x' to exit the system."
  choice = gets.chomp
  case choice
  when 'p'
    puts "Press 'a' to add a product or 'e' to view all products and do some editing."
    puts "Or press 'x' to exit"
    choice = gets.chomp
    if choice == 'a'
      add_product
    elsif choice == 'e'
      edit_product
    else
      puts "Sorry! Please try again."
    end
  when 'c'
    puts "Press 'a' to add or 'e' to edit"
    choice = gets.chomp
    if choice == 'a'
      add_cashier
    elsif choice == 'e'
      edit_cashier
    else
      puts "Sorry! Please try again."
    end
  when 'x'
    puts "Bye!\n\n\n"
    exit  ##why do we need this exit?###
  else
    puts "Not valid, please try again."
  end
end

def add_product
  system "clear"
  puts "\nWhat is the name of the product you would like to add?"
  product_name = gets.chomp.downcase
  puts "\nEnter a brief description of #{product_name}:"
  product_descr = gets.chomp
  puts "\nWhat is the price of #{product_name}?"
  product_price = gets.chomp.to_f

  new_product = Product.new({:name => product_name, :description => product_descr, :price => product_price})
  new_product.save
  puts "#{product_name} has been added!"
  puts "Press 'a' to add another product"
  choice = gets.chomp
  if choice == 'a'
    add_product
  else
    manager_menu
  end
end

def edit_product
  system "clear"
  Product.all.each_with_index do |product, index|
    puts "#{index + 1}: #{product.name}, #{product.description}, which costs #{product.price}"
  end
  puts "Press 'm' to return to the manager menu, or"
  puts "\tpress 'e' to edit or 'd' to delete a product?"
  ed_choice = gets.chomp.downcase
  if ed_choice == 'e'
    puts "\nWhat is the number of the product you would like to edit?"
    product_number = gets.chomp.to_i
    puts "\nWhat is the new name of the product?"
    product_name = gets.chomp.downcase
    puts "\nEnter a new description of #{product_number}:"
    product_descr = gets.chomp
    puts "\nWhat is the new price of #{product_number}?"
    product_price = gets.chomp.to_f

    product_to_update = Product.all[product_number-1]
    updated_product = product_to_update.update({:name => product_name, :description => product_descr, :price => product_price})
    puts "\n\n#{product_name} has been updated."
    puts "\n\nPress 'p' to edit another product"
    choice = gets.chomp.downcase
    if choice == 'p'
      edit_product
    else
      manager_menu
    end
  elsif ed_choice == 'd'
    puts "\nWhat is the name of the product you would like to delete?"
    product_name = gets.chomp.downcase
    # product_to_delete = Product.find_by name: product_name
    Product.where(:name => product_name).destroy_all
    # product_to_delete.destroy
    puts "\n#{product_name} has been destroyed."
  else
    manager_menu
  end
end


###############################################

# def cashier_menu
#   system "clear"

#   puts "Enter the name of the product you would like to ring up."
#   product_name = gets.chomp.downcase
#   puts "\nHow many #{product_name}s is your customer purchasing?"
#   number_of_products = gets.chomp.to_i


# end

welcome


