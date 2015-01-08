class Question < ActiveRecord::Base
	belongs_to :user
	has_many :answers, dependent: :destroy
	has_many :comments, as: :commentable, dependent: :destroy
	has_many :attachments, as: :attachmentable, dependent: :destroy

	validates :title, :body, presence: true

	accepts_nested_attributes_for :attachments
end
