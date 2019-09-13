require 'rest-client'
require 'json'
require 'pry'

class User < ActiveRecord::Base
    has_many :transactions
    has_many :currencies, through: :transactions

    def self.reload
        reset
        load
    end

    def get_data
        response_string = RestClient.get("https://api.nomics.com/v1/currencies/ticker?key=#{token}&ids=BTC,ETH,XRP,USDT,LTC&interval=1d,30d&convert=USD")
        response_hash = JSON.parse(response_string)
        response_hash
    end

    def find_by_name(name)
        coins = get_data
        coins.find{|coin| coin["name"] == name}
    end

    def find_coin_in_db(name)
        Currency.all.find{|currency| currency.name == name}
    end

    def find_user_coin(name)
        self.currencies.find{|currency| currency.name == name}
    end

    def price(name)
        find_by_name(name)["price"].to_f.round(4)
    end

    def get_price_info(name)
        price = find_by_name(name)["price"]
        price_date = find_by_name(name)["price_date"]
        p "The price of #{name} is #{price} on #{price_date}."
    end

    def amount(name)
        coin = self.currencies.find{|currency| currency.name == name}
        amount = 0
        if coin
            coin_transactions = coin.transactions.select{|transaction| transaction.user_id == self.id}
            amount = coin_transactions.map{|transaction| transaction.amount}.sum
        else
            amount = 0
        end
        amount.round(5)
    end

    def get_all_amounts
        names = self.currencies.uniq.map{|currency| currency.name}
        puts names.map{|name| amount(name)}

    end

    def coin_value(name)
        amount(name) * price(name)
    end

    def account_value
        names = self.currencies.uniq.map{|currency| currency.name}
        names.map{|name| coin_value(name)}.sum + self.balance
    end

    def convert_to_coin(name, amount)
        amount / price(name)
    end

    def buy_coin(name, amount)
        coin = find_coin_in_db(name)
        if coin
            if amount <= balance && amount > 0
                amount_of_coins  = convert_to_coin(name, amount)
                Transaction.create(user_id: self.id, currency_id: coin.id, name: name, amount: amount_of_coins, price: price(name), date: DateTime.now)
                self.balance -= amount
                self.save
                self.reload
            else
                if(amount <= 0)
                    puts "Please enter amount greater than 0!"
                else
                    puts "You don't have enough money on your balance!"
                end
            end
        else
            puts "We don't sell such coin on our platform!"
        end
    end   
    
    def sell_coin(name, amount)
        coin  = find_user_coin(name)
        if coin
            if amount(name) >= amount && amount > 0
                amount_of_dollars = amount * price(name)
                Transaction.create(user_id: self.id, currency_id: coin.id, name: name, amount: (amount * -1), price: price(name), date: DateTime.now)
                self.balance += amount_of_dollars
                self.save
                self.reload
            else
                 if(amount <= 0)
                    puts "Please enter amount greater than 0!"
                else
                    puts "You don't have enough coins on your balance!"
                end
            end
        else
            puts "You don't have such coin!"
        end
    end

    def last_five_transactions
        transactions = Transaction.all.where('user_id = ?', self.id).order('date desc').limit(5)
        transactions
    end

    def self.best_traders
        users = User.all.sort_by {|user| user.account_value}.reverse
    end


    def delete_account
        Transaction.all.where('user_id = ?', self.id).each {|transaction| transaction.delete}
        User.find(self.id).delete
    end

    # def delete_currency
    #     coins = self.currencies.select{|currency| self.amount(currency.name) <= 0}

    # end
end

