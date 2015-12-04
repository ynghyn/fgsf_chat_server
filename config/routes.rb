Rails.application.routes.draw do
  root "chat#index"
  get 'chat/get_messages' => 'chat#get_messages'
  post 'chat/create_message' => 'chat#create_message'
  put 'chat/update_name' => 'chat#update_name'
end
