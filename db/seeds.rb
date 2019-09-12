coin1 = Currency.create(name: "Bitcoin", abv: "BTC")
coin2 = Currency.create(name: "Ethereum", abv: "ETH")
coin3 = Currency.create(name: "Ripple", abv: "XRP")
coin4 = Currency.create(name: "Litecoin", abv: "LTC")
coin5 = Currency.create(name: "Tether", abv: "USDT")


user1 = User.create(name: "avinash", password: "2222")
user2 = User.create(name: "andrew", password: "1111")

transaction1 = Transaction.create(user_id: user1.id, currency_id: coin1.id, name: "Bitcoin", amount: 3, price: 10000, date: DateTime.now)
transaction2 = Transaction.create(user_id: user1.id, currency_id: coin2.id, name: "Ethereum", amount: 3, price: 10, date: DateTime.now)
transaction3 = Transaction.create(user_id: user1.id, currency_id: coin4.id, name: "Litecoin", amount: 2, price: 0.2, date: DateTime.now)
transaction4 = Transaction.create(user_id: user1.id, currency_id: coin1.id, name: "Bitcoin", amount: 1, price: 12000, date: DateTime.now)

