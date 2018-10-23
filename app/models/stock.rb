require 'rest-client'
require 'json'
require 'open-uri'
require 'nokogiri'

class Stock < ActiveRecord::Base
	has_many :transactions
	has_many :users, through: :transactions

	@@api_key = "0O9ZU6OG2DM59BBY"

	stock_ticker_api = "https://iextrading.com/trading/eligible-symbols/"
	Nokogiri::HTML(open(stock_ticker_api)).css("div.app tr.bg-silver-on-hover")
	binding.pry

	def self.get_stock_price(ticker_name:)
		# api_url = "https://www.alphavantage.co/query?function=TIME_SERIES_INTRADAY&symbol=#{ticker_name}&interval=1min&apikey=#{@@api_key}"
		# stock_info = stock_hash["Time Series (1min)"][stock_hash["Time Series (1min)"].keys[0]]
		# stock_price = stock_info["4. close"].to_f

		api_url = "https://api.iextrading.com/1.0/stock/#{ticker_name}/chart/dynamic"
		stock_hash = JSON.parse(RestClient.get(api_url))

		stock_info = stock_hash["data"][-1]
		stock_price = stock_info["close"]

		if self.find_by(ticker_name: ticker_name)
			self.find_by(ticker_name: ticker_name).update(stock_price: stock_price)
		else
			self.create(ticker_name: ticker_name, stock_price: stock_price)
		end

		stock_price
	end
end
