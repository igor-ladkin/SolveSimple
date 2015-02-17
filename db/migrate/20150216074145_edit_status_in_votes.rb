class EditStatusInVotes < ActiveRecord::Migration
  def change
  	change_column :votes, :status, :boolean, null: false
  end
end
