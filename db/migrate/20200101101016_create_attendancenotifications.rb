class CreateAttendancenotifications < ActiveRecord::Migration[5.1]
  def change
    create_table :attendancenotifications do |t|
      t.string :status
      t.datetime :applicate_month
      t.integer :visited_id
      t.boolean :checked
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
