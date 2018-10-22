class CreatePurchases < ActiveRecord::Migration[5.0]
	def change
		create_table :purchases do |t|
			t.integer :quantity_shares
			t.integer :stock_id
			t.integer :user_id
		end
	end
end
