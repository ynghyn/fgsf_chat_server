class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :macAddress
      t.string :ipAddress
      t.boolean :disabled
      t.timestamp :lastLoggedInAt

      t.timestamps null: false
    end
  end
end
