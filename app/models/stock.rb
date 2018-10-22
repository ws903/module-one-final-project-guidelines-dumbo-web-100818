# require 'nokogiri'
# require 'open-uri'
require 'rest-client'
require 'json'

class Stock < ActiveRecord::Base
	has_many :purchases
	has_many :users, through: :purchases

	@@api_key = "0O9ZU6OG2DM59BBY"

	def self.collect_from_api(ticker_name:)
		api_url = "https://www.alphavantage.co/query?function=TIME_SERIES_INTRADAY&symbol=#{ticker_name}&interval=1min&apikey=#{@@api_key}"
		response_string = RestClient.get(api_url)
		stock_hash = JSON.parse(response_string)
		stock_info = stock_hash["Time Series (1min)"][stock_hash["Time Series (1min)"].keys[0]]
		stock_price = stock_info["4. close"].to_f
		binding.pry
	end
end