require_relative '../config/environment'
include Login, Main

prompt = TTY::Prompt.new
spinner = TTY::Spinner.new
heart = prompt.decorate('❤ ', :magenta)
user_select = ''

while user_select != 3
	puts `clear`
	user_select = prompt.select( "Welcome to []!!") do |menu|
		menu.choice "Log in", 1
		menu.choice "Create an account", 2
		menu.choice "Exit", 3
	end

	if user_select == 1
		login
	elsif user_select == 2
		create_account
	elsif user_select == 3
		exit
		user_option = 6
	end

	if user_select != 3
		user_option = ''
	end



	while user_option != 6
		puts `clear`
		user_option = prompt.select( "Please select one of the following options:") do |menu|
			menu.enum '.'
			menu.choice "Check balance", 1
			menu.choice "Check stock price", 2
			menu.choice "Buy new stocks", 3
			menu.choice "Sell stocks", 4
			menu.choice "Delete your account", 5
			menu.choice "Log out", 6
		end

		if user_option == 1
			check_balance
		elsif user_option == 2
			check_stock_price
		elsif user_option == 3
			buy_stock
		elsif user_option == 4
			sell_stock
		elsif user_option == 5
			delete_account
			user_option = 6
		elsif user_option == 6
			puts "Goodbye #{@user.username}. Have a great day."
		else
			puts "Choice invalid."
		end
	end
end
