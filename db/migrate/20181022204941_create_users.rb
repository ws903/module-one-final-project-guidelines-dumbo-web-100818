class CreateUsers < ActiveRecord::Migration[5.0]
	def change
		create_table :users do |t|
			t.string :username
			t.float :balance
			t.float :original_balance
		end
	end
end
