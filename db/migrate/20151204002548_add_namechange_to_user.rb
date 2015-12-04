class AddNamechangeToUser < ActiveRecord::Migration
  def change
    add_reference :users, :namechange, index: true, foreign_key: true
  end
end
