# VideoVolunteer-Ruby #

Web application for data entry for Video Volunteers. Uses Sinatra, Activerecord, and Postegre.


Instructions to run after cloning:

> $ bundle install
> $ruby app.rb


For inserting old data into new database (will elaborate later; will also update the process):
* Rename columns with tracker table names
* Make sure all UID names match (case sensitive)
* Run merge_script.rb
* Sort left to right
* Run clean_script.rb
* Delete columns with empty header
* Take a look at duplicate column’s merge conflicts; delete as needed
* Convert to SQL insert (http://www.convertcsv.com/csv-to-sql.htm)
* Insert into database
