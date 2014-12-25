module ApplicationHelper
	def author_of?(record)
		current_user == record.user
	end
end
