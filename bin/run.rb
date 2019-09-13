require_relative '../config/environment'
require 'rest-client'
require 'json'
require 'tty-prompt'
require 'pry'
require 'io/console'



font = TTY::Font.new("3d")
pastel = Pastel.new

puts pastel.red(font.write("Crypto", letter_spacing: 4))
puts pastel.yellow(font.write("Simulator"))

spinner = TTY::Spinner.new
spinner = TTY::Spinner.new("[:spinner] Loading ...".colorize(:green), format: :pulse_2)
spinner.auto_spin
sleep(2)
spinner.stop('Done!') 



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
       system("clear")
       create_account
   else
       system("clear")
       puts "This app was made by A&A Corp. If you would like to see the rude version, please notify Avi later!".colorize(:red)
       return nil
   end
end

def sign_in
   system("clear")
   puts "Enter your username".colorize(:green)
   input_name = gets.chomp
   user = User.all.find{|user| user.name == input_name}
   if user
       system("clear")
       prompt = TTY::Prompt.new
       input_password = prompt.mask("Enter your password:")
       if user.password == input_password
           system("clear")
           menu(user)
       else
           system("clear")
           puts "Wrong password provided".colorize(:red)
           welcome
       end
   else
        system("clear")
        puts "Username doesn't exist!".colorize(:red), ""
        welcome
   end
end

def create_account
    puts "Please enter your desired username!"
    username_input = gets.chomp
    user = User.all.find{|user| user.name == username_input}
    if user
        system("clear")
        puts "This username already taken!"
        welcome
    elsif username_input.length < 3
        system("clear")
        puts "Username is too short"
        welcome
    else
        system("clear")
        prompt = TTY::Prompt.new
        userpassword = prompt.mask("Please enter your desired password:")
        confirm_password = prompt.mask("Please confirm your password:")
        if userpassword == confirm_password && userpassword.length >= 4
            user = User.create(name: username_input, password: userpassword)
            system("clear")
            puts "Your account created successfully!"
            menu(user)
        else
            system("clear")
            puts "Password doesn't match or it's too short (min length 4 characters)!"
            welcome
        end
    end
end

def menu(user)
    prompt = TTY::Prompt.new
    user_input = prompt.select(("==========MENU==========").colorize(:yellow)) do |menu|
        menu.choice 'Check coin balance'.colorize(:green), "C"
        menu.choice 'Total portfolio value'.colorize(:green), "P"
        menu.choice 'Trade'.colorize(:green), "T"
        menu.choice 'Statistic'.colorize(:green), "L"
        # menu.choice 'Best trader of the week'.colorize(:blue), "B"
        menu.choice 'Close the account'.colorize(:red), "A"
        menu.choice 'Exit'.colorize(:red), "See you next time!".colorize(:green).colorize(:background => :light_blue)
    end
    if user_input == "C"
        check_balance(user)
        menu(user)
    elsif user_input == "P"
        total_portfolio_value(user)
        menu(user)
    elsif user_input == "T"
        system("clear")
        trade_menu(user)
    elsif user_input == "L"
        system("clear")
        statistic_menu(user)
    elsif user_input == "A"
        user.delete_account
        system("clear")
        puts "Your account was deleted succesfully!"
        welcome
    else
        system("clear") 
        puts "This app was made by A&A Corp. If you would like to see the rude version, please notify Avi later!".colorize(:red)
        return nil
    end
end

def trade_menu(user)
    prompt = TTY::Prompt.new
    user_input = prompt.select(("What would you like to do today?").colorize(:yellow)) do |menu|
        menu.choice 'Buy'.colorize(:green), "C"
        menu.choice 'Sell'.colorize(:green), "P"
        menu.choice 'Go back'.colorize(:red), "K"
    end
    if user_input == "P"
        system("clear")
        if user.currencies.empty?
            puts "You don't own any coins!".colorize(:red)
            trade_menu(user)
        else
            prompt = TTY::Prompt.new
            user_in = prompt.select(("Choose coin").colorize(:blue)) do |menu|
                user.currencies.uniq.each do |currency|
                    if(user.amount(currency.name) > 0)
                        menu.choice "#{currency.name}: amount:#{user.amount(currency.name)} price(ea): $#{user.price(currency.name).round(2)}", "#{currency.name}"
                    end
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
                system("clear")
                user.sell_coin(user_in, amount.to_f)
                if amount.to_f < user.amount(user_in) && amount.to_f > 0
                    system("clear")
                    puts "Transaction completed."
                    puts "Your new balance is $#{user.balance}"
                    puts "You now have #{user.amount(user_in)} #{user_in}(s)"
                end
                trade_menu(user)
            end
        end
    elsif user_input == "C"
        system("clear")
        prompt = TTY::Prompt.new
        user_in = prompt.select(("Choose coin. Your USD balance: $#{user.balance}").colorize(:blue)) do |menu|
            Currency.all.each do |currency|
                menu.choice "#{currency.name}: price(ea) $#{user.price(currency.name).round(2)}", "#{currency.name}" 
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
            system("clear")
            if amount.to_f < user.balance && amount.to_f > 0
                user.buy_coin(user_in, amount.to_f)
                puts "Transaction completed."
                puts "Your new balance is $#{user.balance.round(2)}"
                puts "You now have #{user.amount(user_in).round(2)} #{user_in}(s)"
            elsif amount.to_f < 0
                puts  "Please enter amount greater than 0!"
            else
                puts  "You don't have enough coin on your balance!"
            end
            trade_menu(user)
        end
    else
        system("clear") 
        menu(user)
    end
end

def statistic_menu(user)
    prompt = TTY::Prompt.new
        user_input = prompt.select(("STATISTIC").colorize(:yellow)) do |menu|
            menu.choice 'Your last five transactions'.colorize(:green), "C"
            menu.choice 'Last five platform transactions'.colorize(:green), "P"
            menu.choice 'Best traders'.colorize(:green), "T"
            menu.choice 'Main menu'.colorize(:red), "E"
        end
        if user_input == "C"
            system("clear")
            user_last_five(user)
            statistic_menu(user)
        elsif user_input == "P"
            system("clear")
            platform_last_five
            statistic_menu(user)
        elsif user_input == "T"
            system("clear")
            best_platform_trader
            statistic_menu(user)
        else
            system("clear")
            menu(user)
        end
end

def total_portfolio_value(user)
    system("clear")
    count = 0
    colors = [:bright_red, :bright_yellow, :bright_green, :bright_magenta, :bright_cyan, :bright_black]
    data = [
      {name: 'USD', value: user.balance, color: colors[count] , fill: '*'}
    ]
    user.currencies.uniq.each do |currency|
        count += 1
        if user.amount(currency.name) > 0
           data << {name: currency.abv, value: user.coin_value(currency.name), color: colors[count], fill: '*'}
        end
    end

    account_val = data.map{|hash| hash[:value]}.sum

    pie_chart = TTY::Pie.new(data: data, radius: 5, legend: {format: "%<name>s $%<value>.2f (%<percent>.2f%%)"})
    print pie_chart
    puts puts "Total portfolio value: $#{account_val.round(2)}"
end


def check_balance(user)
    system("clear")
    if user.currencies.empty?
        puts "You don't own any coins!".colorize(:red)
    else 
        coins = []
        counter = 1
        user.currencies.uniq.each do |currency|
            if user.amount(currency.name) > 0
                coins << ["#{counter}", "#{currency.abv}", "#{user.amount(currency.name).round(2)}", "#{user.price(currency.name).round(2)}", "$#{user.coin_value(currency.name).round(2)}"]
                counter +=1
            end
        end
        table = TTY::Table.new ['No.', 'Name','Ammount', 'Market price', 'Value'], coins
        renderer = TTY::Table::Renderer::Unicode.new(table)
        print renderer.render
        puts
        puts "Your USD balance is: $#{user.balance.round(2)}"
        puts
    end
end

def user_last_five(user)
    if user.transactions.empty?
        puts "You haven't maid any transactions!".colorize(:red)
    else 
        transactions = []
        counter = 1
        user.last_five_transactions.each do |transaction|
            transactions << ["#{counter}", "#{transaction.name}", "#{transaction.amount.round(2)}", "$#{transaction.price.round(2)}", "#{transaction.date}"]
            counter += 1
        end
        table = TTY::Table.new ['No.', 'Name','Coin Amount', 'Rate', 'Date'], transactions
        renderer = TTY::Table::Renderer::Unicode.new(table)
        print renderer.render
        puts
    end
end

def platform_last_five
    if Transaction.all.empty?
        puts "There haven't been any transactions!".colorize(:red)
    else 
        last_five = []
        counter = 1
        transactions = Transaction.all.order('date desc').limit(5)
        transactions.each do |transaction|
            transaction_user = User.find(transaction.user_id)
            last_five << ["#{counter}", "#{transaction_user.name}", "#{transaction.name}", "#{transaction.amount.round(2)}", "$#{transaction.price.round(2)}", "#{transaction.date}"]
            counter += 1
        end
        table = TTY::Table.new ['No.', 'Username', 'Currency','Coin Amount', 'Rate', 'Date'], last_five
        renderer = TTY::Table::Renderer::Unicode.new(table)
        print renderer.render
        puts
    end
end

def best_platform_trader
    traders = []
    counter = 1
    User.best_traders.each do |trader|
        traders << ["#{counter}", "#{trader.name}", "#{trader.account_value.round(2)}"]
        counter +=1
    end
    table = TTY::Table.new ['No.', 'Username','Total Portfolio Value'], traders
    renderer = TTY::Table::Renderer::Unicode.new(table)
    print renderer.render
    puts
end


welcome