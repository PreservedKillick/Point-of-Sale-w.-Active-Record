require 'active_record'
require './lib/product'
require './lib/cashier'
require 'pry'
require 'money'

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
  puts "Press 's' to switch to a cashier user"
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
    puts "Press 'a' to add or 'e' to view all cashiers and do some editing"
    choice = gets.chomp
    if choice == 'a'
      add_cashier
    elsif choice == 'e'
      edit_cashier
    else
      puts "Sorry! Please try again."
    end
  when 's'
    cashier_menu
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
  product_price = gets.chomp
  Money.new(product_price, "USD")  # = sprintf "%.2f" % product_price

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
    puts "#{index + 1}: #{product.name}, #{product.description}, which costs $#{product.price}"
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

def add_cashier
  system "clear"
  puts "\nWhat is the name of the cashier you would like to add?"
  cashier_name = gets.chomp.downcase
  puts "\nEnter #{cashier_name}'s username:"
  cashier_username = gets.chomp

  new_cashier = Cashier.new({:name => cashier_name, :username => cashier_username})
  new_cashier.save
  puts "#{cashier_name} has been added!"
  puts "Press 'a' to add another cashier"
  choice = gets.chomp
  if choice == 'a'
    add_cashier
  else
    manager_menu
  end
end

def edit_cashier
system "clear"
  Cashier.all.each_with_index do |cashier, index|
    puts "#{index + 1}: #{cashier.name}, #{cashier.username}"
  end
  puts "\n\nPress 'm' to return to the manager menu, or"
  puts "\tpress 'e' to edit or 'd' to delete a cashier"
  ed_choice = gets.chomp.downcase
  if ed_choice == 'e'
    puts "\nWhat is the number of the cashier you would like to edit?"
    cashier_number = gets.chomp.to_i
    puts "\nWhat is the new name of the cashier?"
    cashier_name = gets.chomp.downcase
    puts "\nWhat is the new username of the cashier?"
    cashier_username = gets.chomp.downcase

    cashier_to_update = Cashier.all[cashier_number-1]
    updated_cashier = cashier_to_update.update({:name => cashier_name, :username => cashier_username})
    puts "\n\n#{updated_cashier.name} has been updated."
    puts "\n\nPress 'c' to edit another cashier"
    choice = gets.chomp.downcase
    if choice == 'c'
      edit_cashier
    else
      manager_menu
    end
  elsif ed_choice == 'd'
    puts "\nWhat is the name of the user you would like to delete?"
    cashier_name = gets.chomp.downcase
    # product_to_delete = Product.find_by name: product_name
    Cashier.where(:name => cashier_name).destroy_all
    # product_to_delete.destroy
    puts "\n#{cashier_name} has been destroyed."
  else
    manager_menu
  end
end

###############################################

def cashier_menu
  system "clear"

  # puts "Enter your cashier id #"
  final = []
  receipt = []
  choice = nil
  until choice == 'N'
    puts "Would you like to add a product to the checkout? Y/N"
    choice = gets.chomp.upcase

    case choice
    when 'Y'
      puts "Enter the name of the product you would like to ring up."
      product_name = gets.chomp.downcase
      puts "\nHow many #{product_name}s is your customer purchasing?"
      number_of_products = gets.chomp.to_i
      #binding.pry
      unit_price = Product.where(:name => product_name).first.price
      product_cost = unit_price * number_of_products
      final << product_cost
      puts "\n#{number_of_products} #{product_name} added to transaction."
      receipt_line = "#{product_name}\t$#{product_cost}"
      receipt << receipt_line
    when 'N'
      binding.pry
      total = final.inject { |sum, x| sum + x }
      receipt.each { |line| puts line }
      puts "___________________________"
      puts "\nYour total is $#{total}."
    else
      puts "Please enter in a valid entry."
    end
  end
end


  # puts "Would you like to add another product to this transaction?"
  # puts "Y or N?"
  # choice = gets.chomp.dowcase
  # if 'y'
  # cashier_menu
  # elsif 'n'

  # else




welcome


