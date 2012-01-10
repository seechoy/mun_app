class CreateConferences < ActiveRecord::Migration
  def change
    create_table :conferences do |t|
      t.string :title
      t.integer :user_id
      t.string :date
      t.string :location

      t.timestamps
    end
  end
end
