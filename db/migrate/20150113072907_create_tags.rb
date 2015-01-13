class CreateTags < ActiveRecord::Migration
  def change
    create_table :tags do |t|
      t.string :name
    end

    create_table :questions_tags, id: false do |t|
      t.belongs_to :question, index: true
      t.belongs_to :tag, index: true
    end
  end
end
