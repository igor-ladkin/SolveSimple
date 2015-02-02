class Question < ActiveRecord::Base
	belongs_to :user
	has_many :answers, dependent: :destroy, inverse_of: :question
	has_many :comments, as: :commentable, dependent: :destroy
	has_many :attachments, as: :attachmentable, dependent: :destroy
	has_and_belongs_to_many :tags
	before_save :associate_tags

	attr_accessor :tag_names

	validates :title, :body, presence: true

	accepts_nested_attributes_for :attachments, allow_destroy: true

	def solution
		self.answers.find_by(approved: true)
	end

	def has_solution?
		self.solution ? true : false
	end

	private

	def associate_tags
		if tag_names
			tag_names.split(' ').each do |name|
				self.tags << Tag.find_or_create_by(name: name)
			end	
		end
	end
end
