require_relative '../config/environment'

puts "Welcome to []!!"
puts "Username :"
username = gets.chomp
if User.find_by(username: username)
	puts "Welcome back #{username}!"
	user = User.find_by(username: username)
else
	puts "Seems like you don't have an account.  We've created it for you #{username}"
	user = User.create(username: username)
end

Stock.get_stock_price(ticker_name: "FB")
binding.pry
0