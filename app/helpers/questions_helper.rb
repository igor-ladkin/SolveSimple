module QuestionsHelper
	def styling(votable)
		return { up: '', down: '' } unless votable.already_voted_by?(current_user)
		styling = votable.voted_with_by(current_user) ? { up: 'text-success', down: 'text-muted' } : { up: 'text-muted', down: 'text-danger' }
	end
end
