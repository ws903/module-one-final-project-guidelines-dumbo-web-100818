class User < ActiveRecord::Base
	has_many :transactions
	has_many :stocks, through: :transactions

	def init
		self.balance ||= 0
	end
end