require_relative '../config/environment'
prompt = TTY::Prompt.new
heart = prompt.decorate('❤ ', :magenta)


user_select = prompt.select( "Welcome to []!!") do |menu|
	menu.choice "Log in", 1
	menu.choice "Create an account", 2
	menu.choice "Exit", 3
end

if user_select == 1
	username = prompt.ask("Username:") do |q|
	  q.required true
	  q.validate /\A\w+\Z/
	  q.modify   :capitalize
	end
	if User.find_by(username: username)
			puts "Welcome back #{username}!"
			user = User.find_by(username: username)
		else
	puts "Seems like you don't have an account. We've created it for you #{username}"
	user = User.create(username: username)
end

elsif user_select == 2
	username = prompt.ask("Please create a username:") do |q|
	  q.required true
	  q.validate /\A\w+\Z/
	  q.modify   :capitalize
	end
	if User.find_by(username: username)
		puts "Seems like you have an account."
		user = User.find_by(username: username)
		puts "Welcome back #{username}!"
		else
		puts "Welcome #{username}!"
		user = User.create(username: username)
	end
elsif user_select == 3
	puts "Goodbye. Have a great day."
end
#
#
# user_option = ""
# while user_option != 6

user_option = prompt.select( "Please select one of the following options:") do |menu|
	menu.enum '.'
	menu.choice "Check balance", 1
	menu.choice "Check stock price", 2
	menu.choice "Buy new stocks", 3
	menu.choice "Sell stocks", 4
	menu.choice "Delete your account", 5
	menu.choice "Log out", 6
end


# if user_input == "1"
# 	puts "Username :"
# 	username = gets.chomp.downcase
# 	if User.find_by(username: username)
# 		puts "Welcome back #{username}!"
# 		user = User.find_by(username: username)
#
# 	else
# 		puts "Seems like you don't have an account. We've created it for you #{username}"
# 		user = User.create(username: username)
# 	end
#
# elsif user_input == "2"
# 	puts "Please enter a username :"
# 	username = gets.chomp.downcase
# 	if User.find_by(username: username)
# 		puts "Seems like you have an account."
# 		user = User.find_by(username: username)
# 		puts "Welcome back #{username}!"
#
# 	else
# 		puts "Welcome #{username}!"
# 		user = User.create(username: username)
# 	end
# end
#
# user_option = ""
	#
	# puts "Please select one of the following options:\n 1.Check balance\n 2.Check stock price\n 3.Buy new stocks\n 4.Sell stocks\n 5.Delete your account\n 6.Log out"
	# user_option = gets.chomp

	if user_option == 1
		# binding.pry
		user.update_balance
		puts "PORTFOLIO BALANCE: $#{user.balance}"
		user.show_balance

	elsif user_option == 2
		puts "Please enter the name of the stock your want to check:"
		ticker_name = gets.chomp.upcase
		begin
			stock_price = Stock.get_stock_price(ticker_name: ticker_name)
			puts stock_price
			yes_q = prompt.yes?("Do you want to buy this stock?")
			# puts "Do you want to buy this stock? (Y/N)"
			# yes_no = gets.chomp.downcase

			if yes_q
				user.make_transaction(ticker_name: ticker_name)
			else
				user_option = 6
			end

		rescue IEX::Errors::SymbolNotFoundError
			puts "Please enter a valid ticker!"
		end

	elsif user_option == 3
		puts "Please enter the name of the stock you want to buy:"
		ticker_name = gets.chomp.upcase
		begin
			user.make_transaction(ticker_name: ticker_name)
		rescue IEX::Errors::SymbolNotFoundError
			puts "Please enter a valid ticker!"
		end

	elsif user_option == 4
		puts "Please enter the name of the stock your want to sell:"
		ticker_name = gets.chomp.upcase
		begin
			puts "How many #{ticker_name} shares do you want sell (if ALL, please enter ALL):"
			sell_quantity = gets.chomp.downcase

			if sell_quantity == "all"
				user.sell_all_ticker_shares(ticker_name: ticker_name)
			else
				user.sell_n_ticker_shares(ticker_name: ticker_name, sell_quantity: sell_quantity)
			end

		rescue IEX::Errors::SymbolNotFoundError
			puts "Please enter a valid ticker!"
		end

	elsif user_option == 5
		binding.pry
		user.delete_all_transactions
		user.destroy
		puts "Account deleted!"
		user_option = 6

	elsif user_option == 6
		puts "Goodbye. Have a great day."
	else
		puts "Choice invalid."
	end
# end

yes_q = prompt.yes?("Would you like to make another action?")




Stock.get_stock_price(ticker_name: "FB")
