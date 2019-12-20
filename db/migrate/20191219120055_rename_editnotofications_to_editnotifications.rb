class RenameEditnotoficationsToEditnotifications < ActiveRecord::Migration[5.1]
  def change
    rename_table :editnotofications, :editnotifications
  end
end
