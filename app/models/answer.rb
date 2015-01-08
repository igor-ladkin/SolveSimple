class Answer < ActiveRecord::Base
	belongs_to :user
	belongs_to :question
	has_many :comments, as: :commentable, dependent: :destroy
	has_many :attachments, as: :attachmentable, dependent: :destroy

	validates :body, presence: true

	accepts_nested_attributes_for :attachments
end
