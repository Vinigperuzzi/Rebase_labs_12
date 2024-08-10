require 'csv'
require 'pg'
require 'yaml'

class Queries
  attr_accessor :conn, :db_config

  def initialize config_file:, scope:
    connect_to_db(config_file, scope)
  rescue StandardError
    message = 'Impossível conectar ao banco de dados'
  end

  def cpf_all
    query_cpfs = @conn.exec('SELECT cpf FROM exams GROUP BY cpf;')
    cpfs = []
    query_cpfs.each do |cpf|
      cpfs << cpf['cpf']
    end
    cpfs
  end

  def all_tokens_by_cpf(cpf)
    query_tokens = @conn.exec("SELECT token FROM exams WHERE cpf = '#{cpf}' GROUP BY token;")
    tokens = []
    query_tokens.each do |token|
      tokens << token['token']
    end
    tokens
  end

  private

  def connect_to_db config_file, scope
    @db_config = YAML.load_file(config_file)[scope]
    @conn = PG.connect(
      dbname: @db_config['database'],
      user: @db_config['username'],
      password: @db_config['password'],
      host: @db_config['host'],
      port: @db_config['port']
    )
  end
end