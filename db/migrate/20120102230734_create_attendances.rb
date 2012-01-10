class CreateAttendances < ActiveRecord::Migration
  def change
    create_table :attendances do |t|
      t.integer :user_id
      t.integer :conference_id
      t.string :country

      t.timestamps
    end
    add_index :attendances, [:user_id, :conference_id], :unique => true
  end
end
