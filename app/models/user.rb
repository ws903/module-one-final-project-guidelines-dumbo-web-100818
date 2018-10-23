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
		if !!/\A\d+\z/.match(quantity_shares)
			quantity_share = quantity_share.to_i
			Stock.get_stock_price(ticker_name: ticker_name)
			stock = Stock.find_by(ticker_name: ticker_name)
			transaction = Transaction.create(quantity_shares: quantity_shares, stock_price: stock.stock_price, stock_id: stock.id, user_id: self.id)
			puts "Success! You just bougth #{transaction.quantity_shares} #{ticker_name} shares!"
			self.update_balance
		else
			puts "You are trying to make invalid transaction!"
		end
	end

	def update_balance
		total_balance = 0.0

		self.transactions.map {|transaction|
			ticker_name = transaction.stock.ticker_name
			quantity_shares = transaction.quantity_shares
			updated_price = Stock.get_stock_price(ticker_name: ticker_name)
			total_balance += updated_price * quantity_shares
		}
		self.balance = total_balance.round(2)
	end

	def find_transactions(ticker_name:)
		self.transactions.select {|transaction|
			transaction.stock.ticker_name == ticker_name
		}
	end

	def check_original_balance
		original_balance = 0.0

		self.transactions.map {|transaction|
			ticker_name = transaction.stock.ticker_name
			quantity_shares = transaction.quantity_shares
			original_price = transaction.stock_price
			original_balance += (original_price * quantity_shares).round(2)
		}
		return original_balance
	end

	def get_total_quantity_share(ticker_name:)
		find_transactions.reduce(0) {|total, transaction|
			total += transaction.quantity_shares
		}
	end

	def sell_n_ticker_shares(ticker_name:, sell_quantity:)
		if (!!/\A\d+\z/.match(sell_quantity)) && (self.transactions.length) > 0 && (find_transactions(ticker_name: ticker_name).length > 0)
			if sell_quantity.to_i <= get_total_quantity_share(ticker_name: ticker_name)
				sell_quantity = sell_quantity.to_i
				transactions = find_transactions(ticker_name: ticker_name)
				transactions.map {|transaction|
					updated_price = Stock.get_stock_price(ticker_name: ticker_name)
					if transaction.quantity_shares < sell_quantity
						self.balance -= (updated_price * sell_quantity).round(2)
						transaction.quantity_shares -= sell_quantity
					else
						self.balance -= (updated_price * sell_quantity).round(2)
						transaction.quantity_shares -= sell_quantity
					end

				}
			end
		else
			puts "You are trying to make invalid transaction!"
		end
	end

	def sell_all_ticker_shares(ticker_name:)
		find_transactions(ticker_name: ticker_name).map{|transaction|
			transaction.destroy
		}
		user.update_balance
	end

	def delete_all_transactions
		Transaction.where(user_id: self.id).destroy_all
	end
end
