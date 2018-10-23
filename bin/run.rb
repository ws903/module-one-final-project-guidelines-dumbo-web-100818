require_relative '../config/environment'

puts "Welcome to []!!"
puts "1. Log in 2. Create account "
user_input = gets.chomp
if user_input == "1"
	puts "Username :"
	username = gets.chomp.downcase
	if User.find_by(username: username)
	puts "Welcome back #{username}!"
	user = User.find_by(username: username)
	else
		puts "Seems like you don't have an account. We've created it for you #{username}"
	user = User.create(username: username)
end
	elsif user_input == "2"
		puts "Please enter a username :"
		username = gets.chomp.downcase
		if User.find_by(username: username)
			puts "Seems like you have an account."
			user = User.find_by(username: username)
			puts "Welcome back #{username}!"
		else
			puts "Welcome #{username}!"
			user = User.create(username: username)
		end
	end


		puts "Please select one of the following options: 1.Check balance 2.check stock price 3.Buy new stocks 4.Sell stocks 5.Delete your account 6.Log out"
			user_option = gets.chomp
			if user_option == "1"
				puts "Your current balance is :#{User.balance}"
			elsif user_option == "2"
					puts "Please enter the name of the stock your want to check:"
					ticker_name = gets.chomp
					stock_price = Stock.get_stock_price(ticker_name: ticker_name)
					puts stock_price
					puts "Do you want to buy this stock?"

				elsif user_option == "3"
					puts "Please enter the name of the stock you want to buy:"
					stock_name = gets.chomp

				end









Stock.get_stock_price(ticker_name: "FB")
binding.pry
0
