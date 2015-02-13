module Votable
	extend ActiveSupport::Concern

	included do
		has_many :votes, as: :votable, dependent: :delete_all
		has_many :voted_users, through: :votes, source: :user, source_type: 'User'
	end

	def thumbs_up(user)
	end

	def thumbs_down(user)
	end
end