	require 'colorize'
module Login
	PROMPT = TTY::Prompt.new
	SPINNER = TTY::Spinner.new(":title [:spinner] ", format: :arrow_pulse)


	def login
		username = PROMPT.ask("Username:") do |q|
		  q.required true
		  q.validate /\A\w+\Z/
		  q.modify   :capitalize
		end

		if User.find_by(username: username)
				@user = User.find_by(username: username)
				show_spinner_login("\n\nWelcome back #{username}!")
		else
			puts "Seems like you don't have an account. We've created it for you #{username}"
			@user = User.create(username: username)
			show_spinner_login("\n\nWelcome #{username}!")
		end
	end

	def create_account
		username = PROMPT.ask("Please create a username:") do |q|
		  q.required true
		  q.validate /\A\w+\Z/
		  q.modify   :capitalize
		end

		if User.find_by(username: username)
			puts "Seems like you have an account."
			@user = User.find_by(username: username)
			show_spinner_login("\n\nWelcome back #{username}!")
		else
			@user = User.create(username: username)
			show_spinner_login("\n\nWelcome #{username}!")
		end
	end

	def exit_page
		user_option = 6
		puts "Goodbye. Have a great day."
	end

	def show_spinner_login(stop_msg)
		SPINNER.update(title: "Logging you in")
		SPINNER.auto_spin
		sleep(2)
		SPINNER.stop
		puts `clear`
		puts stop_msg.colorize(:color => :light_blue, :mode => :bold)
		sleep(1)
	end
end
