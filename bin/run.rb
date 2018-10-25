require_relative '../config/environment'
include Login, Main

prompt = TTY::Prompt.new
heart = prompt.decorate('❤ ', :magenta)

user_select = 0
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
		exit_page
		user_option = 6
	end

	if user_select != 3
		user_option = 0
	end
	sleep(3)
	puts `clear`

	while user_option != 6
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
			puts `clear`
			check_balance
		elsif user_option == 2
			puts `clear`
			check_stock_price
		elsif user_option == 3
			puts `clear`
			buy_stock
		elsif user_option == 4
			puts `clear`
			sell_stock
		elsif user_option == 5
			puts `clear`
			user_option = delete_account
		elsif user_option == 6
			puts `clear`
			puts "Goodbye #{@user.username}. Have a great day."
		else
			puts `clear`
			puts "Choice invalid."
		end
	end
end
