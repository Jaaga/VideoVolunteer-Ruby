# VideoVolunteer-Ruby #

Web application for data entry for Video Volunteers. Uses Sinatra, Activerecord, and MySQL.

Instructions to run after cloning:

> $ bundle install


Make sure you have MySQL installed on your machine.
Make sure your MySQL username is 'root' and password is ''. Otherwise, you will need to change the files under the ./.config folder to match your MySQL credentials.
> $ sudo mysql

> CREATE DATABASE videovol;
> grant all privileges on videovol.* to ‘root'@'localhost' identified by ‘’;
> FLUSH PRIVILEGES;


After creating database, run:
> $ mysql -u root -p videovol < videovol.sql


Everything should now be setup.
> $ ruby app.rb
