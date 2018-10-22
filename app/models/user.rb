class User < ActiveRecord::Base
	has_many :purchase
	has_many :stocks, through: :purchases
end