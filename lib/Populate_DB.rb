# This script create the exams table in labs_db database, in case that it does not exists already
# and then populate the database with the data from /public/csv/data.csv
# Note: all the current data from the DB will be erased and overwritten by the data
#       in the csv file

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

db_config = YAML.load_file('./config/db.config')['development']

conn = PG.connect(
  dbname: db_config['database'],
  user: db_config['username'],
  password: db_config['password'],
  host: db_config['host'],
  port: db_config['port']
)

table = db_config['table1']

puts '________________________________________________'
puts '|Criando a tabela Exams, caso ela já não exista|'
puts '¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨'

conn.exec("CREATE TABLE IF NOT EXISTS #{table} ( \
          cpf varchar(20), \
          full_name varchar(100) NOT NULL, \
          email varchar(100) NOT NULL, \
          birth_date date, \
          address varchar(100), \
          city varchar(50), \
          state varchar(50), \
          dr_crm varchar(15), \
          dr_state varchar(50), \
          dr_name varchar(100), \
          dr_email varchar(100), \
          token varchar(10), \
          exam_date date, \
          exam_type varchar(50), \
          exam_type_limits varchar(20), \
          exam_type_value varchar(10), \
          PRIMARY KEY (cpf, token, exam_type) \
          );")

puts '_______________________________________________'
puts '|Apagando os dados da tabelas exams do labs_db|'
puts '¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨'

conn.exec("delete from #{table}")

puts '_____________________________________________________'
puts '|Inserindo os dados do arquivo csv no banco de dados|'
puts '¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨'

data.each do |row|
  conn.exec("INSERT INTO \
              #{table} ( \
                cpf, \
                full_name, \
                email, \
                birth_date, \
                address, \
                city, \
                state, \
                dr_crm, \
                dr_state, \
                dr_name, \
                dr_email, \
                token, \
                exam_date, \
                exam_type, \
                exam_type_limits, \
                exam_type_value \
              ) \
              VALUES ( $1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16)",
              [
                row['cpf'],
                row['nome paciente'],
                row['email paciente'],
                row['data nascimento paciente'],
                row['endereço/rua paciente'],
                row['cidade paciente'],
                row['estado patiente'],
                row['crm médico'],
                row['crm médico estado'],
                row['nome médico'],
                row['email médico'],
                row['token resultado exame'],
                row['data exame'],
                row['tipo exame'],
                row['limites tipo exame'],
                row['resultado tipo exame']
              ])
end