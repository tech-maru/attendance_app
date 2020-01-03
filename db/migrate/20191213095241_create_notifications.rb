class CreateNotifications < ActiveRecord::Migration[5.1]
  def change
    create_table :notifications do |t|
      t.integer :visited_id, null: false
      t.datetime :scheduled_end_time
      t.string :status, default: '', null: false
      t.string :note, default: '', null: false
      t.boolean :next_day, default: false, null: false
      t.boolean :checked, default: false, null: false
      t.references :user, foreign_key: true
      t.references :attendance, foreign_key: true

      t.timestamps
    end
    
  end
end
