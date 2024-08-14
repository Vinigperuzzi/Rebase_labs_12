require 'csv'
require 'erb'
require 'pg'
require 'rack/handler/puma'
require 'sinatra'
require 'yaml'
require 'json'
require 'sidekiq/web'
require 'sidekiq/api'
require 'rack-protection'
require './lib/workers/csv_import_worker'
require_relative './src/queries'
require_relative './src/manipulate_db'

secret_key = SecureRandom.hex(64)
configure do
  set :session_token, SecureRandom.hex(64)
end

use Rack::Session::Cookie, secret: settings.session_token
use Rack::Protection, except: :http_origin

Sidekiq.configure_server do |config|
  config.redis = { url: 'redis://redis:6379/1' }
end

Sidekiq.configure_client do |config|
  config.redis = { url: 'redis://redis:6379/1' }
end

def initializa_queries(params)
  scope = (ENV['RACK_ENV'] == 'test') || params[:cypress_test] ? 'test' : 'container'
  Queries.new(config_file: './config/db.config', scope: scope)
end

get '/exams-dark' do
  content_type :html

  html_path = './public/views/exams_dark.html'

  if File.exist?(html_path)
    File.read(html_path)
  else
    status 404
    'Arquivo não encontrado'
  end
end

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

get '/exams/:token' do
  token = params[:token]
  content_type :html

  html_path = './public/views/exams_details.html.erb'

  if File.exist?(html_path)
    template = File.read(html_path)
    erb_template = ERB.new(template)

    erb_template.result(binding)
  else
    status 404
    'Arquivo não encontrado'
  end
end

get '/exams-dark/:token' do
  token = params[:token]
  content_type :html

  html_path = './public/views/exams_details_dark.html.erb'

  if File.exist?(html_path)
    template = File.read(html_path)
    erb_template = ERB.new(template)

    erb_template.result(binding)
  else
    status 404
    'Arquivo não encontrado'
  end
end

get '/all_cpfs' do
  content_type :json
  dql = initializa_queries(params)
  cpfs = dql.cpf_all
  cpfs_list = []
  cpfs.each do |cpf|
    cpfs_list << cpf
  end
  cpfs_list.to_json
end

get '/all_cpf_tokens/:cpf' do
  content_type :json
  dql = initializa_queries(params)
  tokens = dql.all_tokens_by_cpf(params[:cpf])
  token_list = []
  tokens.each do |token|
    token_list << token
  end
  token_list.to_json
end

get '/all_token_info/:token' do
  content_type :json
  dql = initializa_queries(params)
  dql.all_info_by_token(params[:token]).to_json
end

get '/all_cpf_info/:cpf' do
  content_type :json
  dql = initializa_queries(params)
  dql.all_info_by_cpf(params[:cpf]).to_json
end

get '/all_token_types/:token' do
  content_type :json
  dql = initializa_queries(params)
  types = dql.all_exams_types_by_token(params[:token])
  all_types = []
  types.each do |type|
    all_types << type
  end
  all_types.to_json
end

get '/tests' do
  content_type :json
  dql = initializa_queries(params)
  dql.tests.to_json
rescue StandardError
  'Não há dados a serem exibidos, ou o não foi possível conectar ao banco'
end

get '/tests/:token' do
  content_type :json
  dql = initializa_queries(params)
  data = dql.test(params[:token]).to_json
  return nil if data.nil?

  data
end

post '/import' do
  if params[:file] && params[:file][:tempfile]
    file_path = params[:file][:tempfile].path
    scope = (ENV['RACK_ENV'] == 'test') || params[:cypress_test] ? 'test' : 'container'
    db = ManipulateDB.new(csv_file: file_path, config_file: './config/db.config', scope: 'container')
    db.populate_add_db
    status 202
  else
    status 400
  end
end

get '/hello' do
  'Hello world!'
end

get '/sidekiq' do
  run Sidekiq::Web
end

post '/populate_test_db' do
  data = params['file_data']
  db = ManipulateDB.new(csv_file: data, config_file: './config/db.config', scope: 'test')
  db.populate_db
  status 200
end

post '/drop_test_db' do
  db = ManipulateDB.new(csv_file: './public/csv/data2.csv', config_file: './config/db.config', scope: 'test')
  db.drop_exams
  status 200
end

unless ENV['RACK_ENV'] == 'test'
  Rack::Handler::Puma.run(
    Sinatra::Application,
    Port: 3000,
    Host: '0.0.0.0'
  )
end
