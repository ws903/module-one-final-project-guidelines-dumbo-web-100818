class CreateTransactions < ActiveRecord::Migration[5.0]
	def change
		create_table :transactions do |t|
			t.integer :quantity_shares
			t.float :stock_price
			t.timestamp :stock_time
			t.integer :stock_id
			t.integer :user_id
		end
	end
end
