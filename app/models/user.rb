class User < ActiveRecord::Base
	has_many :transactions
	has_many :stocks, through: :transactions
	after_initialize :init

	def init
		self.balance ||= 0
	end

	def make_transaction(ticker_name:)
		puts "How many shares?"
		quantity_shares = gets.chomp
		Stock.get_stock_price(ticker_name: ticker_name)
		self.update_balance
		stock = Stock.find_by(ticker_name: ticker_name)
		transaction = Transaction.create(quantity_shares: quantity_shares, stock_price: stock.stock_price, stock_id: stock.id, user_id: self.id)
		transaction_price = transaction.stock_price * transaction.quantity_shares
		self.balance += transaction_price
		puts "Success! You just bougth #{transaction.quantity_shares} #{ticker_name} shares!"
	end

	def update_balance
		total_balance = 0.0

		self.transactions.map {|transaction|
			ticker_name = transaction.stock.ticker_name
			quantity_shares = transaction.quantity_shares
			updated_price = Stock.get_stock_price(ticker_name: ticker_name)
			total_balance += updated_price * quantity_shares
		}
		self.balance = total_balance
	end

	def find_transaction(ticker_name:)
		self.transactions.find {|transaction|
			transaction.stock.ticker_name == ticker_name
		}
	end

	def check_original_balance
		original_balance = 0.0

		self.transactions.map {|transaction|
			ticker_name = transaction.stock.ticker_name
			quantity_shares = transaction.quantity_shares
			original_price = transaction.stock_price
			original_balance += original_price * quantity_shares
		}
		return original_balance
	end

	def sell_n_ticker_shares(ticker_name:, sell_quantity:)
		transaction = find_transaction(ticker_name: ticker_name)
		update_balance
		updated_price = Stock.get_stock_price(ticker_name: ticker_name)
		self.balance -= updated_price * sell_quantity.to_f
		transaction.quantity_shares -= sell_quantity.to_f
	end

	def sell_all_ticker_shares(ticker_name:)
		user.update_balance
		find_transaction(ticker_name: ticker_name).destroy
	end
end
