class User < ActiveRecord::Base
  has_many :name_changes
  
  attr_accessor :name

  # User hashmap (ie: user_id => User)
  @@all_users = Hash[User.all.map { |user| [user.id, user] }]
  
  after_create { @@all_users[self.id] = self }
  after_save { @@all_users[self.id] = self }

  def self.users
    @@all_users
  end

  def self.update_last_logged_in(user_id)
    @@all_users[user_id].lastLoggedInAt = Time.now
  end

  def self.currently_active_users
    @@all_users.select { |user_id, user| user.lastLoggedInAt && user.lastLoggedInAt > 7.seconds.ago }
  end

  def self.users_were_updated
    !!@@all_users.find { |user_id, user| user.updated_at > 4.seconds.ago }
  end

  def name
    @name ||= namechange_id ? NameChange.find(namechange_id).name : "user-#{self.id}"
  end
end
