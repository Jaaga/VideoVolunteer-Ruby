require './app'
run Sinatra::Application

# For heroku logs
$stdout.sync = true
