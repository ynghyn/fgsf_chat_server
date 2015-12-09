class Message < ActiveRecord::Base
  belongs_to :user
  belongs_to :chatroom
  
  @@last_message_id = Message.last.id

  after_create { @@last_message_id = Message.last.id }

  NUM_MSGS_TO_RETRIEVE = 50

  def self.last_message_id
    @@last_message_id
  end

  # WARNING: this logic only works for ONE chatroom.
  def self.get_new_messages(message_id, chatroom_id, bypass)
    if Message.last_message_id > message_id || bypass
      #Message.where("id > ? AND chatroom_id = ?", message_id, chatroom_id).last(NUM_MSGS_TO_RETRIEVE)
      Message.where(:chatroom_id => chatroom_id).last(NUM_MSGS_TO_RETRIEVE)
    end
  end
end
