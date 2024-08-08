require 'csv'
require 'pg'
require 'yaml'

rows = CSV.read('./public/csv/data.csv', col_sep: ';')

columns = rows.shift

data = rows.map do |row|
  row.each_with_object({}).with_index do |(cell, acc), idx|
    column = columns[idx]
    acc[column] = cell
  end
end

puts data.length
puts data[3899]['cpf']

db_config = YAML.load_file('./config/db.config')['development']

conn = PG.connect(
  dbname: db_config['database'],
  user: db_config['username'],
  password: db_config['password'],
  host: db_config['host'],
  port: db_config['port']
)

query = conn.exec('SELECT * FROM exams')

query.each do |value|
  puts value
end