module Main
	include Login
	PROMPT = TTY::Prompt.new

	def check_balance
		@user.update_balance
		puts "PORTFOLIO BALANCE: $#{@user.balance}"
		@user.show_balance
	end

	def check_stock_price
		puts "Please enter the name of the stock your want to check:"
		ticker_name = gets.chomp.upcase

		begin
			stock_price = Stock.get_stock_price(ticker_name: ticker_name)
			puts stock_price
			yes_q = prompt.yes?("Do you want to buy this stock?")

			if yes_q
				@user.make_transaction(ticker_name: ticker_name)
			else
				@user_option = 6
			end

		rescue IEX::Errors::SymbolNotFoundError
			puts "Please enter a valid ticker!"
		end
	end

	def buy_stock
		puts "Please enter the name of the stock you want to buy:"
		ticker_name = gets.chomp.upcase

		begin
			@user.make_transaction(ticker_name: ticker_name)
		rescue IEX::Errors::SymbolNotFoundError
			puts "Please enter a valid ticker!"
		end
	end

	def sell_stock
		puts "Please enter the name of the stock your want to sell:"
		ticker_name = gets.chomp.upcase

		begin
			puts "How many #{ticker_name} shares do you want sell (if ALL, please enter ALL):"
			sell_quantity = gets.chomp.downcase

			if sell_quantity == "all"
				@user.sell_all_ticker_shares(ticker_name: ticker_name)
			else
				@user.sell_n_ticker_shares(ticker_name: ticker_name, sell_quantity: sell_quantity)
			end

			puts "Success! You sold #{sell_quantity} #{ticker_name} shares!"

		rescue IEX::Errors::SymbolNotFoundError
			puts "Please enter a valid ticker!"
		end
	end

	def delete_account
		@user.delete_all_transactions
		@user.destroy
		puts "Account deleted!"
	end
	
end