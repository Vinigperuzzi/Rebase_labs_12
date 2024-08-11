require 'csv'
require 'pg'
require 'rack/handler/puma'
require 'sinatra'
require 'yaml'
require 'json'
require_relative './src/queries.rb'

get '/exams' do
  content_type :html

  html_path = './public/views/exams.html'

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
  dql = Queries.new(config_file: './config/db.config', scope: scope)
  cpfs = dql.cpf_all
  tokens_list = []
  cpfs.each do |cpf|
    tokens = dql.all_tokens_by_cpf(cpf)
    tokens.each do |token|
      tokens_list << token
    end
  end
  all_types = []
  tokens_list.each do |token|
    types = dql.all_exams_types_by_token(token)
    types.each do |type|
      all_types << type
    end
  end
  all_types.to_json
end

get '/all_cpfs' do
  content_type :json
  scope = ENV['RACK_ENV'] == 'test' ? 'test' : 'container'
  dql = Queries.new(config_file: './config/db.config', scope: scope)
  cpfs = dql.cpf_all
  cpfs_list = []
  cpfs.each do |cpf|
    cpfs_list << cpf
  end
  cpfs_list.to_json
end

get '/all_cpf_tokens/:cpf' do
  content_type :json
  scope = ENV['RACK_ENV'] == 'test' ? 'test' : 'container'
  dql = Queries.new(config_file: './config/db.config', scope: scope)
  tokens = dql.all_tokens_by_cpf(params[:cpf])
  token_list = []
  tokens.each do |token|
    token_list << token
  end
  token_list.to_json
end

get '/all_token_info/:token' do
  content_type :json
  scope = ENV['RACK_ENV'] == 'test' ? 'test' : 'container'
  dql = Queries.new(config_file: './config/db.config', scope: scope)
  dql.all_info_by_token(params[:token]).to_json
end

get '/all_token_types/:token' do
  content_type :json
  scope = ENV['RACK_ENV'] == 'test' ? 'test' : 'container'
  dql = Queries.new(config_file: './config/db.config', scope: scope)
  types = dql.all_exams_types_by_token(params[:token])
  all_types = []
  types.each do |type|
    all_types << type
  end
  all_types.to_json
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
