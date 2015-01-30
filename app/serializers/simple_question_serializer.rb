class SimpleQuestionSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :created_at, :updated_at, :short_title

  def short_title
  	object.title.truncate(20)
  end
end