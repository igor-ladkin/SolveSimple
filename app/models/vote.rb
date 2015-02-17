class Vote < ActiveRecord::Base
	belongs_to :user
  belongs_to :votable, polymorphic: true, counter_cache: true

  validates :user_id, uniqueness: { scope: [:votable_id, :votable_type] }

  after_create :calculate_votable_rating
  after_update :recalculate_votable_rating, :if => :status_changed?

  protected 

  def calculate_votable_rating
  	votable.rating += status ? 1 : -1
  	votable.save!
  end

  def recalculate_votable_rating
  	self.status ? votable.rating += 2 : votable.rating -= 2
  	votable.save!
  end
end
