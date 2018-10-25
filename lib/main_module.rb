module Main
	include Login

	def check_balance
		user_choice = 0
		show_spinner("Done!")
		while user_choice != @user.stocks.uniq.count+1
			puts "PORTFOLIO BALANCE: $#{@user.balance}"
			@user.show_stocks

			ticker_hash = {}
			user_choice = PROMPT.select("Which stock do you want to check?") do |menu|
				c = 1
				@user.stocks.uniq.map {|stock|
					menu.choice stock.ticker_name, c
					ticker_hash[c] = stock.ticker_name
					c += 1
				}
				menu.choice "exit", c
			end

			if user_choice != @user.stocks.uniq.count+1
				show_spinner("Done!")
				@user.show_balance(ticker_name: ticker_hash[user_choice])
			end
		end
	end

	def check_stock_price
		puts "Please enter the name of the stock your want to check:"
		ticker_name = gets.chomp.upcase

		begin
			stock = Stock.get_stock(ticker_name: ticker_name)
			puts "$ #{stock.stock_price}"
			yes_q = PROMPT.yes?("Do you want to buy this stock?")

			if yes_q
				puts "How many shares?"
				quantity_shares = gets.chomp
				@user.make_transaction(ticker_name: ticker_name, quantity_shares: quantity_shares)
			else
				@user_option = 6
			end

			show_spinner("\nSuccess! \nYou just bougth #{quantity_shares} #{ticker_name} shares!")

		rescue IEX::Errors::SymbolNotFoundError, URI::InvalidURIError
			puts `clear`
			puts "Please enter a valid ticker!".colorize(:color => :red, :mode => :bold)
		end
	end

	def buy_stock
		puts "Please enter the name of the stock you want to buy:"
		ticker_name = gets.chomp.upcase

		begin
			puts "How many shares?"
			quantity_shares = gets.chomp
			@user.make_transaction(ticker_name: ticker_name, quantity_shares: quantity_shares)
			show_spinner("\nSuccess! \nYou just bougth #{quantity_shares} #{ticker_name} shares!")
		rescue IEX::Errors::SymbolNotFoundError, URI::InvalidURIError
			puts `clear`
			puts "Please enter a valid ticker!".colorize(:color => :red, :mode => :bold)
		end
	end

	def sell_stock
		puts "Please enter the name of the stock your want to sell:"
		ticker_name = gets.chomp.upcase

		begin
			puts "How many #{ticker_name} shares do you want sell (if ALL, please enter ALL):"
			sell_quantity = gets.chomp.downcase
			sold = false

			if sell_quantity == "all"
				sold = @user.sell_all_ticker_shares(ticker_name: ticker_name)
			else
				sold = @user.sell_n_ticker_shares(ticker_name: ticker_name, sell_quantity: sell_quantity)
			end

			if sold
				show_spinner("\nSuccess! \nYou sold #{sell_quantity} #{ticker_name} shares!")
			end

		rescue IEX::Errors::SymbolNotFoundError, URI::InvalidURIError
			puts `clear`
			puts "Please enter a valid ticker!".colorize(:color => :red, :mode => :bold)
		end
	end

	def delete_account
		delete_q = PROMPT.yes?("Are you sure you want to perform this action?")
		if delete_q
			@user.delete_all_transactions
			@user.destroy
			show_spinner("\nSuccess! \nAccount deleted!")
			return 6
		else
			puts "Glad you decided to stay with us!"
			sleep(1)
			puts `clear`
			return 0
		end
	end

	def show_spinner(stop_msg)
		SPINNER.update(title: "Performing task")
		SPINNER.auto_spin
		sleep(2)
		SPINNER.stop(stop_msg.colorize(:color => :green, :mode => :bold))
		sleep(1)
		puts `clear`
	end
end
