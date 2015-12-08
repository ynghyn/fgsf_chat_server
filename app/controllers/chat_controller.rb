class ChatController < ApplicationController
  def index
    # Create user and store in cookie if one doesn't exist
    if !cookies[:user_id]
      user = create_and_get_user
      cookies[:user_id] = {
        value: user.id,
        expires: 10.years.from_now
      }
    end
    @chatroom_id = ChatRoom::PUBLIC_CHATROOM_ID
    @user_id = cookies[:user_id]
  end

  def get_messages
    raise ArgumentError.new("invalid argument") unless params[:chatroom_id]
    messages = Message.get_new_messages(params[:message_id].to_i, params[:chatroom_id])
    render json: format_html_message(messages)
  end

  def update_name
    raise ArgumentError.new("invalid argument") unless params[:user_id] && params[:name]
    user = User.find(params[:user_id])
    name_change = NameChange.create(:user => user, :name => params[:name])
    user.namechange_id = name_change.id
    user.save
    render json: { :status => 200}
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
    messages = messages.map do |message|
      {
        :user => message.user.name,
        :message => message.message,
        :created_at => message.created_at
      }
    end
    { :messages => messages }
  end
  
  def format_html_message(messages)
	  messages = messages.map do |message|
	  	"#{message.user.name} [#{l message.created_at, format: :short}]: #{message.message}"
		end
    { :messages => messages }
  end
end
