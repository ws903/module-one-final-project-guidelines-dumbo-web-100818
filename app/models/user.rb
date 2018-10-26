require 'tty'
require 'colorize'
require 'date'

class User < ActiveRecord::Base
	has_many :transactions
	has_many :stocks, through: :transactions
	after_initialize :init

	def init
		self.balance ||= 0
	end

	def make_transaction(ticker_name:, quantity_shares:)
		bought = false
		if !!/\A\d+\z/.match(quantity_shares)
			quantity_shares = quantity_shares.to_i
			stock = Stock.get_stock(ticker_name: ticker_name)
			stock_time = Time.at(stock.latest_update/1000).to_datetime.to_s
			Transaction.create(quantity_shares: quantity_shares, stock_price: stock.stock_price, stock_time: stock_time, stock_id: stock.id, user_id: self.id)
			self.update_balance
			bought = true
		else
			puts "You are trying to make invalid transaction!".colorize(:color => :red, :mode => :bold)
		end
		bought
	end

	def show_stocks
		table = TTY::Table.new header: ['Stock', 'Shares', 'Total Price']
		self.update_balance
		self.stocks.uniq.map {|stock|
			shares = self.transactions.where(stock_id: stock.id).sum("quantity_shares")
			stock_price = stock.stock_price
			total_price = (stock_price * shares).round(2)

			table << [stock.ticker_name, shares, total_price]
		}

		puts table.render(:unicode)
	end

	def show_balance(ticker_name:)
		table = TTY::Table.new header: ['Stock', 'Buy Price', 'Current Price', 'Change %', 'Shares', 'Purchase Time']
		self.update_balance
		transaction_stock = self.stocks.find_by(ticker_name: ticker_name)
		self.transactions.where(stock_id: transaction_stock.id).order(:stock_time).map {|transaction|
			stock = transaction.stock
			stock_original_price = transaction.stock_price
			stock_price = stock.stock_price
			diff_perc = (((stock_price - stock_original_price)/stock_original_price) * 100).round(2)
			diff_perc_str = "#{diff_perc} %"
			if diff_perc < 0
					diff_perc_str = diff_perc_str.colorize(:color => :red, :mode => :bold)
			elsif diff_perc > 0
					diff_perc_str = diff_perc_str.colorize(:color => :green, :mode => :bold)
			end

			shares = transaction.quantity_shares
			table << [stock.ticker_name, stock_original_price, stock_price, diff_perc_str, shares, transaction.stock_time]
		}
		puts table.render(:unicode)
	end

	def update_balance
		total_balance = 0.0

		self.transactions.map {|transaction|
			ticker_name = transaction.stock.ticker_name
			quantity_shares = transaction.quantity_shares
			stock = Stock.get_stock(ticker_name: ticker_name)
			total_balance += stock.stock_price * quantity_shares
		}

		self.balance = total_balance.round(2)
		User.where(id: self.id).update(balance: self.balance)
	end

	def find_transactions(ticker_name:)
		self.transactions.select {|transaction|
			transaction.stock.ticker_name == ticker_name
		}
	end

	def sell_n_ticker_shares(ticker_name:, sell_quantity:)
		sold = false
		stock = Stock.find_by(ticker_name: ticker_name)

		if (!!/\A\d+\z/.match(sell_quantity)) && (self.transactions.length) > 0 && (find_transactions(ticker_name: ticker_name).length > 0)
			if sell_quantity.to_i <= self.transactions.where(stock_id: stock.id).sum("quantity_shares")
				sell_quantity = sell_quantity.to_i
				transactions = find_transactions(ticker_name: ticker_name)
				transactions.map {|transaction|
					stock = Stock.get_stock(ticker_name: ticker_name)
					if transaction.quantity_shares <= sell_quantity
						tmp_sell_quantity = sell_quantity - (sell_quantity - transaction.quantity_shares)
						sell_quantity = (sell_quantity - transaction.quantity_shares)

						self.balance -= (tmp_sell_quantity * stock.stock_price)
						User.where(id: self.id).update(balance: (self.balance - (stock.stock_price * tmp_sell_quantity)).round(2))
						self.transactions.delete(transaction)
					elsif sell_quantity == 0
						break
					else
						binding.pry
						self.balance -= (sell_quantity * stock.stock_price)
						User.where(id: self.id).update(balance: (self.balance - (stock.stock_price * sell_quantity)).round(2))
						# transaction.quantity_shares -= sell_quantity
						transaction.update(quantity_shares: transaction.quantity_shares - sell_quantity)
						sell_quantity = 0
					end
				}
				sold = true
			else
				puts "You are trying to make invalid transaction!".colorize(:color => :red, :mode => :bold)
			end
		else
			puts "You are trying to make invalid transaction!".colorize(:color => :red, :mode => :bold)
		end
		return sold
	end

	def sell_all_ticker_shares(ticker_name:)
		find_transactions(ticker_name: ticker_name).map{|transaction|
			transaction.destroy
		}
		self.update_balance
	end

	def delete_all_transactions
		Transaction.where(user_id: self.id).destroy_all
	end
end
