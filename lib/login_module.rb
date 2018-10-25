module Login
	PROMPT = TTY::Prompt.new

	def login
		username = PROMPT.ask("Username:") do |q|
		  q.required true
		  q.validate /\A\w+\Z/
		  q.modify   :capitalize
		end

		if User.find_by(username: username)
				puts "Welcome back #{username}!"
				@user = User.find_by(username: username)
		else
			puts "Seems like you don't have an account. We've created it for you #{username}"
			@user = User.create(username: username)
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
			puts "Welcome back #{username}!"
		else
			puts "Welcome #{username}!"
			@user = User.create(username: username)
		end
	end

	def exit
		user_option = 6
		puts "Goodbye. Have a great day."
	end
end