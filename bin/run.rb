require_relative '../config/environment'
require 'rest-client'
require 'json'
require 'tty-prompt'
require 'pry'



font = TTY::Font.new(:starwars)
pastel = Pastel.new

puts pastel.blue(font.write("Crypto", letter_spacing: 4))
puts pastel.yellow(font.write("Simulator"))

spinner = TTY::Spinner.new
spinner = TTY::Spinner.new("[:spinner] Loading ...".colorize(:green), format: :pulse_2)

spinner.auto_spin # Automatic animation with default interval

sleep(2) # Perform task

spinner.stop('Done!') # Stop animation


def welcome
   prompt = TTY::Prompt.new
   user_input = prompt.select(("Welcome to Crypto Simulator!").colorize(:yellow)) do |menu|
       menu.choice 'Sign In'.colorize(:green), "S"
       menu.choice 'Sign up'.colorize(:green), "C"
       menu.choice 'Exit'.colorize(:red), "See you next time!".colorize(:green).colorize(:background => :light_blue)
   end
   if user_input == "S"
       sign_in
   elsif user_input == "C"
       create_account
   else
       return nil
   end
end

def sign_in
   puts "Enter your username".colorize(:green)
   input_name = gets.chomp
   user = User.all.find{|user| user.name == input_name}
   if user
       puts "Enter your password"
       input_password = gets.chomp
       if user.password == input_password
           menu(user)
       else
           puts "Wrong password provided".colorize(:red)
           welcome
       end
   else
       puts "Username doesn't exist!".colorize(:red), ""
       welcome
   end
end

def create_account
    puts "Please enter your desired username!"
    username_input = gets.chomp
    user = User.all.find{|user| user.name == username_input}
    if user
        puts "This username already taken!"
        create_account
    else
        puts "Please enter your desired password!"
        userpassword = gets.chomp
        User.create(name: username_input, password: userpassword)
        puts "Your account created successfully!"
        menu
    end
end

def menu(user)
    
    prompt = TTY::Prompt.new
    user_input = prompt.select(("What would you like to today?").colorize(:yellow)) do |menu|
        menu.choice 'Check balance'.colorize(:green), "C"
        menu.choice 'Total portfolio value'.colorize(:green), "P"
        menu.choice 'Trade'.colorize(:green), "T"
        menu.choice 'Your last five transactions'.colorize(:green), "L"
        menu.choice 'Best trader of the week'.colorize(:blue), "B"
        menu.choice 'Close the account'.colorize(:red), "A"
        menu.choice 'Exit'.colorize(:red), "See you next time!".colorize(:green).colorize(:background => :light_blue)
   end
    if user_input == "C"
        check_balance(user)
        menu(user)
    elsif user_input == "P"
        total_portfolio_value(user)
        puts "Total portfolio value: $#{user.account_value.round(2)}"
        menu(user)
    elsif user_input == "T"
        trade_menu(user)
    elsif user_input == "L"
        last_five
    elsif user_input == "B"
        best_trader
    elsif user_input == "A"
        close_account
    else 
        return nil
    end
end

def trade_menu(user)
    prompt = TTY::Prompt.new
    user_input = prompt.select(("What would you like to today?").colorize(:yellow)) do |menu|
        menu.choice 'Buy'.colorize(:green), "C"
        menu.choice 'Sell'.colorize(:green), "P"
        menu.choice 'Go back'.colorize(:red), "K"
    end
    if user_input == "P"
        prompt = TTY::Prompt.new
        user_in = prompt.select(("Choose coin").colorize(:blue)) do |menu|
            user.currencies.uniq.each do |currency|
                menu.choice "#{currency.name}: amount:#{user.amount(currency.name)} price(ea): $#{user.price(currency.name)}", "#{currency.name}"
            end
            menu.choice "Go back".colorize(:red), "B"
            menu.choice "Main menu".colorize(:red), "M"
        end
        if user_in == "B"
            trade_menu(user)
        elsif user_in == "M"
            menu(user)
        else
            puts "How much would you like to sell? Enter amount please:"
            amount = gets.chomp
            user.sell_coin(user_in, amount.to_f)
            puts "Transaction completed."
            puts "Your new balance is $#{user.balance}"
            puts "You now have #{user.amount(user_in)} #{user_in}(s)"
            trade_menu(user)
        end
    elsif user_input == "C"
        prompt = TTY::Prompt.new
        user_in = prompt.select(("Choose coin").colorize(:blue)) do |menu|
            Currency.all.each do |currency|
                menu.choice "#{currency.name}: price(ea) $#{user.price(currency.name)}", "#{currency.name}" 
            end
            menu.choice "Go back".colorize(:red), "B"
            menu.choice "Main menu".colorize(:red), "M"
        end
        if user_in == "B"
            trade_menu(user)
        elsif user_in == "M"
            menu(user)
        else
            puts "How much would you like to invest? Enter amount please:"
            amount = gets.chomp
            user.buy_coin(user_in, amount.to_f)
            puts "Transaction completed."
            puts "Your new balance is $#{user.balance}"
            puts "You now have #{user.amount(user_in)} #{user_in}(s)"
            trade_menu(user)
        end
    else 
        menu(user)
    end
end


def total_portfolio_value(user)
    count = 0
    colors = [:bright_red, :bright_yellow, :bright_green, :bright_magenta, :bright_cyan, :bright_black]
    data = [
      {name: 'USD', value: user.balance, color: colors[count] , fill: '*'}
    ]
    user.currencies.uniq.each do |currency|
        count += 1
        data << {name: currency.abv, value: user.coin_value(currency.name), color: colors[count], fill: '*'}
    end

    pie_chart = TTY::Pie.new(data: data, radius: 5, legend: {format: "%<name>s $%<value>d (%<percent>.2f%%)"})
    print pie_chart
end


def check_balance(user)
    coins = []
    user.currencies.uniq.each do |currency|
        coins << ["#{currency.abv}", "#{user.amount(currency.name).round(3)}", "#{user.price(currency.name).round(2)}", "$#{user.coin_value(currency.name).round(2)}"]
    end
    table = TTY::Table.new ['Name','Ammount', 'Market price', 'Value'], coins
    renderer = TTY::Table::Renderer::Unicode.new(table)
    print renderer.render
    puts
end
welcome