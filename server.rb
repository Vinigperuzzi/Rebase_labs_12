require 'csv'
require 'pg'
require 'rack/handler/puma'
require 'sinatra'
require 'yaml'
require 'json'

get '/tests' do
  content_type :json
  db_config = YAML.load_file('config/db.config')['development']
  conn = PG.connect(
    dbname: db_config['database'],
    user: db_config['username'],
    password: db_config['password'],
    host: 'db',
    port: db_config['port']
  )

  rows = conn.exec('SELECT * FROM exams')

  result = []
  rows.each do |row|
    result << row
  end
  result.to_json
end

get '/hello' do
  'Hello world!'
end

Rack::Handler::Puma.run(
  Sinatra::Application,
  Port: 3000,
  Host: '0.0.0.0'
)
