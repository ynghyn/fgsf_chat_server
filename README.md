# FGSF Chat Server

##### SETUP
- For Ubuntu, refer to http://railsapps.github.io/installrubyonrails-ubuntu.html

1. Setup RVM with Ruby 2.2.3 (SQLite is given by RVM and Rails 4.2.5 is defined within the Rails project)

	`>> \curl -sSL https://get.rvm.io | bash -s stable --ruby`

	`>> rvm install ruby-2.2.3`

	`>> rvm --default use ruby-2.2.3`

2. Clone fgsf chat server from Github

	`>> git clone https://github.com/ynghyn/fgsf_chat_server workspace`

3. Bundle gems and initialize DB

	`>> bundle install`

	`>> rake db:migrate`

4. Initialize db entry for a chatroom

	`>> rails console`

	`>> ChatRoom.create(:name => "Public")`

5. Run Rails server
	1. On foreground process
	
		`>> sudo rails s -b 0.0.0.0 -p 80`
	
		0.0.0.0:80 allows wifi connection to server by name, ie: http://yonghyuns-macbook.local/)

	2. In background process as daemon:
	
		`>> sudo rails s -b 0.0.0.0 -p80 -d`
	
		* to kill daemon
	
			`>> cat tmp/pids/server.pid`
	
			`>> kill process_id`


### Initializing Rails app

#####Controller:
rails generate controller Chat

#####DB initialization:
rails generate model ChatRoom name:string private:boolean

rails generate model NameChange name:string user:references

rails generate model User macAdderss:string ipAdderss:string disabled:boolean lastLoggedInAt:timestamp

rails generate migration add_namechange_to_user namechange:references

rails generate model Message message:string user:references chatroom:references

rails generate migration add_color_to_user color:string
rake db:migrate

#####Router:
* chat#index - initial user creation and info gathering logic
* chat/get_messages - retrieves last N messages for selected chatroom
* chat/create_message - posts a new message for current user
* chat/update_name - updates name of current user
* chat/update_color - chat#update_color'

#####Models:
- User, NameChange, ChatRoom, Message

#####Views:
- Bootstrap, jQuery color picker


#### FUTURE WORK:

1. For TCP enabled client-server connection, use Puma

gem 'puma'

bundle exec puma -p 80

site: http://ngauthier.com/2013/02/rails-4-sse-notify-listen.html

site: http://tenderlovemaking.com/2012/07/30/is-it-live.html

puma: http://puma.io/


