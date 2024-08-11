require 'csv'
require 'pg'
require 'rack/handler/puma'
require 'sinatra'
require 'yaml'
require 'json'
require_relative './src/queries.rb'

get '/home' do
  content_type :html

  html_path = './public/views/home.html.erb'

  if File.exist?(html_path)
    File.read(html_path)
  else
    status 404
    'Arquivo não encontrado'
  end
end

get '/test' do
  content_type :json
  scope = ENV['RACK_ENV'] == 'test' ? 'test' : 'container'
  dql = Queries.new(config_file: './config/db.config', scope: 'container')
  cpfs = dql.cpf_all
  tokens_list = []
  cpfs.each do |cpf|
    tokens = dql.all_tokens_by_cpf(cpf)
    tokens.each do |token|
      tokens_list << token
    end
  end
  tokens_list.to_json
end

get '/tests' do
  content_type :json
  scope = ENV['RACK_ENV'] == 'test' ? 'test' : 'container'
  db_config = YAML.load_file('config/db.config')[scope]
  conn = PG.connect(
    dbname: db_config['database'],
    user: db_config['username'],
    password: db_config['password'],
    host: db_config['host'],
    port: db_config['port']
  )

  table = db_config['table1']

  rows = conn.exec("SELECT * FROM #{table}")

  result = []
  rows.each do |row|
    result << row
  end
  result.to_json
rescue
  'Não há dados a serem exibidos, ou o não foi possível conectar ao banco'
end

get '/hello' do
  'Hello world!'
end

unless ENV['RACK_ENV'] == 'test'
  Rack::Handler::Puma.run(
    Sinatra::Application,
    Port: 3000,
    Host: '0.0.0.0'
  )
end
