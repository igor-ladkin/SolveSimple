class ChangeRatingFromFloatToInteger < ActiveRecord::Migration
  def change
  	change_column :questions, :rating, :integer
  	change_column :answers, :rating, :integer
  end
end
