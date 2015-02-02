class Answer < ActiveRecord::Base
	belongs_to :user
	belongs_to :question, inverse_of: :answers
	has_many :comments, as: :commentable, dependent: :destroy
	has_many :attachments, as: :attachmentable, dependent: :destroy

	validates :body, presence: true

	accepts_nested_attributes_for :attachments

  default_scope { order("approved DESC, created_at") }

	def approve
		question = self.question

		if question.has_solution? && (question.solution != self)
			question.solution.update(approved: false)
      self.update(approved: true)
		elsif !question.has_solution?
			self.update(approved: true)
		end

		self
	end

  def is_a_solution?
    self.approved
  end
end
