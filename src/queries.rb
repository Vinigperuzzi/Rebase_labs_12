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
    @conn.exec('SELECT cpf FROM exams GROUP BY cpf;')
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