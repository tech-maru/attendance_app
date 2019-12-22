class CreateEditnotofications < ActiveRecord::Migration[5.1]
  def change
    create_table :editnotofications do |t|
      t.integer :visited_id
      t.datetime :before_started_at
      t.datetime :before_finished_at
      t.datetime :after_started_at
      t.datetime :after_finished_at
      t.string :note
      t.string :status, default: '', null: false
      t.boolean :checked, default: false, null: false
      t.boolean :next_day, default: false, null: false
      t.references :user, foreign_key: true
      t.references :attendance, foreign_key: true

      t.timestamps
    end
  end
end
