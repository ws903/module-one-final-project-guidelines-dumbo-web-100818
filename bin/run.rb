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

user_option = ""
while user_option != "6"
	puts "Please select one of the following options:\n 1.Check balance\n 2.Check stock price\n 3.Buy new stocks\n 4.Sell stocks\n 5.Delete your account\n 6.Log out"
	user_option = gets.chomp

	if user_option == "1"
		user.update_balance
		original_balance = user.check_original_balance
		puts "Your original investment total is: $#{original_balance}"
		puts "Your current balance is : $#{user.balance}"


	elsif user_option == "2"
		puts "Please enter the name of the stock your want to check:"
		ticker_name = gets.chomp
		begin
			stock_price = Stock.get_stock_price(ticker_name: ticker_name)
			puts stock_price
			puts "Do you want to buy this stock? (Y/N)"
			yes_no = gets.chomp.downcase

			if yes_no == 'y'
				user.make_transaction(ticker_name: ticker_name)
			else

			end

		rescue RestClient::NotFound
			puts "Please enter a valid ticker!"
		end

	elsif user_option == "3"
		puts "Please enter the name of the stock you want to buy:"
		ticker_name = gets.chomp
		begin
			user.make_transaction(ticker_name: ticker_name)
		rescue RestClient::NotFound
			puts "Please enter a valid ticker!"
		end

	elsif user_option == "4"
		puts "Please enter the name of the stock your want to sell:"
		ticker_name = gets.chomp
		begin
			puts "How many #{ticker_name} shares do you want sell (if ALL, please enter ALL):"
			sell_quantity = gets.chomp.downcase

			if sell_quantity == "all"
				user.sell_all_ticker_shares(ticker_name: ticker_name)
			else
				user.sell_n_ticker_shares(ticker_name: ticker_name, sell_quantity: sell_quantity)
			end

		rescue RestClient::NotFound
			puts "Please enter a valid ticker!"
		end

	elsif user_option == "5"
		user.delete_all_transactions
		user.destroy
		puts "Account deleted!"
		user_option = "6"

	elsif user_option == "6"
		puts "Goodbye. Have a great day."
	else
		puts "Choice invalid."
	end
end


Stock.get_stock_price(ticker_name: "FB")
