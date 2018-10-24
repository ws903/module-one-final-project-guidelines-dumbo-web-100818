require 'rest-client'
require 'json'
require 'iex-ruby-client'

class Stock < ActiveRecord::Base
	has_many :transactions
	has_many :users, through: :transactions

	def self.get_stock_price(ticker_name:)
		# api_url = "https://api.iextrading.com/1.0/stock/#{ticker_name}/chart/dynamic"
		# stock_hash = JSON.parse(RestClient.get(api_url))

		# stock_info = stock_hash["data"][-1]
		# stock_price = stock_info["close"]

		quote = IEX::Resources::Quote.get(ticker_name)
		stock_price = quote.latest_price

		self.find_or_create_by(ticker_name: ticker_name).update(stock_price: stock_price)

		stock_price
	end
end