# FGSF Chat Server

### SETUP
- For Ubuntu, refer to http://railsapps.github.io/installrubyonrails-ubuntu.html
- sudo apt-get update
- sudo apt-get install git-core curl zlib1g-dev build-essential libssl-dev libreadline-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev libcurl4-openssl-dev python-software-properties libffi-dev
- sudo apt-get install build-essential bison openssl libreadline6 libreadline6-dev curl git-core zlib1g zlib1g-dev libssl-dev libyaml-dev libxml2-dev autoconf libc6-dev ncurses-dev automake libtool
- sudo apt-get install libgmp-dev
- rvm requirements
- gem install bundler
- gem install rails -v 4.2.5

1. Setup RVM with Ruby 2.2.3 (SQLite is given by RVM and Rails 4.2.5 is defined within the Rails project)

	`>> curl -SSL https://get.rvm.io | bash -s stable --ruby`

	`>> rvm install ruby-2.2.3`

	`>> rvm --default use ruby-2.2.3`

2. Clone FGSF chat server from Github

	`>> git clone https://github.com/ynghyn/fgsf_chat_server`

3. Bundle gems and initialize DB

	`>> bundle install`

	`>> rake db:migrate`

4. Initialize db entry for a chatroom

	`>> rails console`

	`console> ChatRoom.create(:name => "Public")`

5. Run Rails server
	1. On foreground process

		`>> rails s -b 0.0.0.0 -p 80`
		- 0.0.0.0:80 allows wifi connection to server by name, ie: http://yonghyuns-macbook.local/)
	2. In background process as daemon:

		`>> rails s -b 0.0.0.0 -p80 -d`
		* to kill daemon
	
			`>> cat tmp/pids/server.pid`
	
			`>> kill process_id`


### Initializing Rails app

#####1. Controller:
* rails generate controller Chat

#####2. DB initialization:
* rails generate model ChatRoom name:string private:boolean
* rails generate model NameChange name:string user:references
* rails generate model User macAdderss:string ipAdderss:string disabled:boolean lastLoggedInAt:timestamp
* rails generate migration add_namechange_to_user namechange:references
* rails generate model Message message:string user:references chatroom:references
* rails generate migration add_color_to_user color:string
* rake db:migrate

#####3. Router:
* chat#index - initial user creation and info gathering logic
* chat/get_messages - retrieves last N messages for selected chatroom
* chat/create_message - posts a new message for current user
* chat/update_name - updates name of current user
* chat/update_color - chat#update_color'

#####4. Models:
- User, NameChange, ChatRoom, Message

#####5. Views:
- Bootstrap, jQuery color picker


#### FUTURE WORK:

1. For TCP enabled client-server connection, use Puma
	- gem 'puma'
	- bundle exec puma -p 80
	- site: http://ngauthier.com/2013/02/rails-4-sse-notify-listen.html
	- site: http://tenderlovemaking.com/2012/07/30/is-it-live.html
	- puma: http://puma.io/


