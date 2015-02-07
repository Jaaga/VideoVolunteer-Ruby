# VideoVolunteer-Ruby #

Web application for data entry for Video Volunteers. Uses Sinatra, Activerecord, and MySQL.


Instructions to run after cloning:

$ bundle install


Make sure you have MySQL installed on your machine.
Make sure your MySQL username is 'root' and password is ''.
$ sudo mysql
CREATE DATABASE videovol;
grant all privileges on videovol.* to ‘root'@'localhost' identified by ‘’;
FLUSH PRIVILEGES;


After creating database, run:
$ mysql -u root -p videovol < videovol.sql


Everything should now be setup.
$ruby app.rb


For inserting old data into new database (will elaborate later; will also update the process):
* Rename columns with tracker table names
* Make sure all UID names match (case sensitive)
* Open in Numbers, then export
* Run test
* Sort left to right
* Export from Numbers
* Run script
* Delete columns with empty header
* Take a look at duplicate column’s merge conflicts, then delete
* Order columns in Excel based on custom sort order (table_template)
* Convert to SQL insert for ‘trackerOld' (http://www.convertcsv.com/csv-to-sql.htm)
* Insert into database
