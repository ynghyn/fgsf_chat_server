class ChatController < ApplicationController
  def index
    # Create user and store in cookie if one doesn't exist
    current_user = if !cookies[:user_id]
      user = create_and_get_user
      cookies[:user_id] = {
        value: user.id,
        expires: 10.years.from_now
      }
      user
    else
      User.find(cookies[:user_id])
    end
    @chatroom_id = ChatRoom::PUBLIC_CHATROOM_ID
    @user = current_user
    @user_id = current_user.id
    @color = current_user.color || "#000000"
  end

  def get_messages
    raise ArgumentError.new("invalid argument") unless params[:chatroom_id]
    messages = Message.get_new_messages(params[:message_id].to_i, params[:chatroom_id])
    render json: format_json_messages(messages)
  end

  def update_name
    raise ArgumentError.new("invalid argument") unless params[:user_id] && params[:name]
    user = User.find(params[:user_id])
    name_change = NameChange.create(:user => user, :name => params[:name])
    user.namechange_id = name_change.id
    user.save
    render json: {}
  end

  def update_color
    raise ArgumentError.new("invalid argument") unless params[:user_id] && params[:color]
    user = User.find(params[:user_id])
    user.color = params[:color]
    user.save
    render json: {}
  end

  def create_message
    raise ArgumentError.new("invalid argument") unless params[:user_id] && params[:chatroom_id] && params[:message]
    user = User.find(params[:user_id])
    chatroom = ChatRoom.find(params[:chatroom_id])
    message = params[:message]
    Message.create(:user => user, :chatroom_id => chatroom.id, :message => message)
    messages = Message.get_last_messages(params[:chatroom_id])
    render json: format_json_messages(messages)
  end

  private

  def create_and_get_user
    User.create(:lastLoggedInAt => Time.now)
  end

  def format_json_messages(messages)
	  converted_messages = messages.map do |message|
      time = message.created_at.in_time_zone("Pacific Time (US & Canada)")
      {
        :color => message.user.color,
        :time => time.strftime("%b%e-%l:%M%P"),
        :username => message.user.name,
        :message => message.message
      }
		end
    { :messages => converted_messages, :lastMessageId => messages.last.id }
  end
end
