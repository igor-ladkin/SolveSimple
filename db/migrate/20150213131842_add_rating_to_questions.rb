class AddRatingToQuestions < ActiveRecord::Migration
  def change
    add_column :questions, :rating, :float, default: 0
  end
end
