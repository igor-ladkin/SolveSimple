class Question < ActiveRecord::Base
	include Votable

	belongs_to :user
	has_many :answers, dependent: :destroy, inverse_of: :question
	has_many :comments, as: :commentable, dependent: :destroy
	has_many :attachments, as: :attachmentable, dependent: :destroy
	has_and_belongs_to_many :tags

	before_save :associate_tags

	attr_writer :tag_names

	validates :title, :body, presence: true

	accepts_nested_attributes_for :attachments, allow_destroy: true

	scope :latest, -> { where("created_at >= ?", Time.zone.now - 1.day) }

	def solution
		answers.find_by(approved: true)
	end

	def has_solution?
		solution ? true : false
	end

	def tag_names
		@tag_names || tags.pluck(:name).join(', ')
	end

	def self.tagged_with(name)
		Tag.find_by!(name: name).questions
	end

	private

	def associate_tags
		if @tag_names
			self.tags = @tag_names.split(',').map do |name|
				Tag.find_or_create_by(name: name.strip)
			end
		end
	end
end
