require 'csv'
require 'json'
require 'pg'
require 'yaml'

class Queries
  attr_accessor :conn, :db_config

  def initialize(config_file:, scope:)
    connect_to_db(config_file, scope)
  rescue StandardError
    'Impossível conectar ao banco de dados'
  end

  def cpf_all
    query_cpfs = @conn.exec('SELECT cpf FROM exams GROUP BY cpf, full_name ORDER BY full_name;')
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

  def all_info_by_cpf(cpf)
    query_info = @conn.exec("SELECT cpf, full_name, birth_date, email, address, city, state \
                             FROM exams \
                             WHERE cpf = '#{cpf}' \
                             limit 1;
                            ")
    query_info.first
  end

  def all_info_by_token(token)
    query_info = @conn.exec("SELECT dr_crm, dr_state, dr_name, dr_email, token, exam_date \
                             FROM exams \
                             WHERE token = '#{token}' \
                             limit 1;
                            ")
    query_info.first
  end

  def all_exams_types_by_token(token)
    query_types = @conn.exec("SELECT exam_type, exam_type_limits, exam_type_value \
                              FROM exams \
                              WHERE token = '#{token}';
                            ")
    types = []
    query_types.each do |type|
      types << type
    end
    types
  end

  def tests
    tokens_query = @conn.exec("SELECT token FROM exams GROUP BY token ORDER BY token")
    tokens = []
    tokens_query.each do |token|
      tokens << token['token']
    end
    json_list = []
    tokens.each do |token|
      query_info = @conn.exec("SELECT cpf, full_name, birth_date, email, address, city, state, dr_crm, \
                              dr_state, dr_name, dr_email, token, exam_date \
                              FROM exams \
                              WHERE token = '#{token}' \
                              limit 1;
                            ")
      info = query_info.first
      types = all_exams_types_by_token(token)
      types_json = []
      types.each do |type|
        type_json = {
          type: type['exam_type'],
          limits: type['exam_type_limits'],
          result: type['exam_type_value']
        }
        types_json << type_json
      end
      json = {
        result_token: info['token'],
        result_date: info['exam_date'],
        cpf: info['cpf'],
        name: info['full_name'],
        email: info['email'],
        birthday: info['birth_date'],
        doctor: {
          crm: info['dr_crm'],
          crm_state: info['dr_state'],
          name: info['dr_name']
        },
        tests: types_json
      }
      json_list << json
    end
    json_list
  end

  private

  def connect_to_db(config_file, scope)
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
