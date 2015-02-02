class AddApprovedToAnswers < ActiveRecord::Migration
  def change
  	add_column :answers, :approved, :boolean, default: false
  end
end
