class User < ActiveRecord::Base
  has_many :name_changes

  def name
    NameChange.find(namechange_id).name
  end
end
