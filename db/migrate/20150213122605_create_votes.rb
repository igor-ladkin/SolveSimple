class CreateVotes < ActiveRecord::Migration
  def change
    create_table :votes do |t|
      t.boolean :status
      t.references :votable, polymorphic: true, index: true

      t.timestamps
    end
  end
end
