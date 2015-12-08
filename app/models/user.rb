class User < ActiveRecord::Base
  has_many :name_changes

  def name
    if namechange_id
      NameChange.find(namechange_id).name
    else
      "user-#{self.id}"
    end
  end
end
