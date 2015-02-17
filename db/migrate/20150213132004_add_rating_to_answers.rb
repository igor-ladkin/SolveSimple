class AddRatingToAnswers < ActiveRecord::Migration
  def change
    add_column :answers, :rating, :float, default: 0
  end
end
