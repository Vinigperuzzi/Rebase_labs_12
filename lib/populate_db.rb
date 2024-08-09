require './src/manipulate_db'

db = ManipulateDB.new(csv_file: './public/csv/data.csv', config_file: './config/db.config', scope: 'development')
db.populate_db
