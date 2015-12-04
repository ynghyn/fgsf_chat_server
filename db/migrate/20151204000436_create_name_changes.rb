class CreateNameChanges < ActiveRecord::Migration
  def change
    create_table :name_changes do |t|
      t.string :name
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
