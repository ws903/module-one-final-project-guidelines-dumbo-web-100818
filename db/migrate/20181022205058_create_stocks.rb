class CreateStocks < ActiveRecord::Migration[5.0]
	def change
		create_table :stocks do |t|
			t.string :ticker_name
			t.float :stock_price
			t.timestamp :latest_update
		end
	end
end
