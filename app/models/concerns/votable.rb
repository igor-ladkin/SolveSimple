module Votable
	extend ActiveSupport::Concern

	included do
		has_many :votes, as: :votable, dependent: :delete_all
		has_many :voted_users, through: :votes, source: :user
	end

	def thumbs_up(user)
		vote = votes.find_or_initialize_by(user: user)
		vote.status = true
		vote.save!
	end

	def thumbs_down(user)
		vote = votes.find_or_initialize_by(user: user)
		vote.status = false
		vote.save!
	end

	def already_voted_by?(user)
		votes.where(user: user).size != 0 ? true : false
	end

	def voted_with_by(user)
		votes.find_by(user: user).status
	end

	def rating_in_percent
		return '0' if votes.size == 0 
		percentage = (votes.size + rating.to_i) / (votes.size * 2.0) * 100
		"%.3g" % percentage
	end
end