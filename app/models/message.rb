class Message < ActiveRecord::Base
  belongs_to :user
  belongs_to :chatroom

  NUM_MSGS_TO_RETRIEVE = 50

  def self.get_last_messages(chatroom_id)
    Message.where(:chatroom_id => chatroom_id).last(NUM_MSGS_TO_RETRIEVE)
  end

  def self.get_new_messages(message_id, chatroom_id)
    Message.where("id > ? AND chatroom_id = ?", message_id, chatroom_id).last(NUM_MSGS_TO_RETRIEVE)
  end
end
