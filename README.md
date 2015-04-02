# VideoVolunteer - Ruby #


Note: this is an unfinished project that has been replaced by another version
built on rails. See https://github.com/Jaaga/VideoVolunteers-Rails for the most
up-to date version of the app. I will be leaving this up for whoever at Jaaga
wants to play around with the code or make it more complete.
Things that can be added/changed: account verification emails, a better
testing suite, etc.


Web application for data entry for Video Volunteers. Built using Sinatra,
Activerecord, PostegreSQL, HAML, and RSpec for testing. Webshims is used for
cross-browser functionality for the HTML5 forms.


## Instructions to run after cloning

> $ bundle install

> $ruby app.rb

## Project Layout

Folder | Notes
--- | ---
/lib | Contains all ruby files with methods created for this project.
/spec | Testing files.
/views | All haml files. Divided by database table names.
