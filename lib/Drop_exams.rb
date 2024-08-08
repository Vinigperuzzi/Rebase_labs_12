require 'pg'
require 'yaml'

db_config = YAML.load_file('./config/db.config')['development']

conn = PG.connect(
  dbname: db_config['database'],
  user: db_config['username'],
  password: db_config['password'],
  host: db_config['host'],
  port: db_config['port']
)

table = db_config['table1']
conn.exec("DELETE FROM #{table}")

puts '________________________________________________'
puts '|Todos os dados foram removidos da tabela Exams|'
puts '¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨'

conn.exec("DROP TABLE #{table}")

puts '________________________________________'
puts '|Tabela exams exluída do bando de dados|'
puts '¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨'