require 'rack/test'
require 'rspec'
require_relative '../../server'
require_relative '../../src/manipulate_db'

before(:all) do
  @db_config = YAML.load_file('./config/db.config')['test']
  @conn = PG.connect(dbname: @db_config['database'],
                     user: @db_config['username'],
                     password: @db_config['password'],
                     host: @db_config['host'],
                     port: @db_config['port'])
  @conn.exec('DROP TABLE IF EXISTS exams')
rescue StandardError
  puts 'Impossível conectar ao banco de dados de teste, rode o comando docker compose up -d --build para poder testar'
  exit!
end

after(:all) do
  @conn.exec('DROP TABLE IF EXISTS exams')
end

describe 'GET endpoints' do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  context 'GET /all_cpfs' do
    it 'returns all cpfs in database' do
      db = ManipulateDB.new(csv_file: './spec/support/five_cpfs.csv', config_file: './config/db.config', scope: 'test')
      db.populate_db

      get '/all_cpfs'

      expect(last_response.status).to eq(200)

      cpfs = JSON.parse(last_response.body)
      expect(cpfs.length).to eq 5
      expect(cpfs[0]).to eq '048.973.170-88'
      expect(cpfs[1]).to eq '077.411.587-40'
      expect(cpfs[2]).to eq '083.892.729-70'
      expect(cpfs[3]).to eq '066.126.400-90'
      expect(cpfs[4]).to eq '089.034.562-70'
    end
  end

  context 'GET /all_cpf_tokens/048.973.170-88' do
    it 'returns all tokens for the specified cpf' do
      db = ManipulateDB.new(csv_file: './spec/support/five_token_same_cpf.csv', config_file: './config/db.config',
                            scope: 'test')
      db.populate_db

      get '/all_cpf_tokens/048.973.170-88'

      tokens = JSON.parse(last_response.body)
      expect(tokens.length).to eq 5
      expect(tokens[0]).to eq 'IQCZ01'
      expect(tokens[1]).to eq 'IQCZ02'
      expect(tokens[2]).to eq 'IQCZ03'
      expect(tokens[3]).to eq 'IQCZ04'
      expect(tokens[4]).to eq 'IQCZ05'
    end
  end

  context 'GET /all_token_types/IQCZ17' do
    it 'returns all types for the specified cpf' do
      db = ManipulateDB.new(csv_file: './spec/support/exam_with_13_types.csv', config_file: './config/db.config',
                            scope: 'test')
      db.populate_db

      get '/all_token_types/IQCZ17'

      types = JSON.parse(last_response.body)
      expect(types.length).to eq 13
      expect(types[0]['exam_type']).to eq 'hemácias'
      expect(types[0]['exam_type_limits']).to eq '45-52'
      expect(types[0]['exam_type_value']).to eq '97'

      expect(types[1]['exam_type']).to eq 'leucócitos'
      expect(types[1]['exam_type_limits']).to eq '9-61'
      expect(types[1]['exam_type_value']).to eq '89'

      expect(types[2]['exam_type']).to eq 'plaquetas'
      expect(types[2]['exam_type_limits']).to eq '11-93'
      expect(types[2]['exam_type_value']).to eq '97'

      expect(types[3]['exam_type']).to eq 'hdl'
      expect(types[3]['exam_type_limits']).to eq '19-75'
      expect(types[3]['exam_type_value']).to eq '0'

      expect(types[4]['exam_type']).to eq 'ldl'
      expect(types[4]['exam_type_limits']).to eq '45-54'
      expect(types[4]['exam_type_value']).to eq '80'

      expect(types[5]['exam_type']).to eq 'vldl'
      expect(types[5]['exam_type_limits']).to eq '48-72'
      expect(types[5]['exam_type_value']).to eq '82'

      expect(types[6]['exam_type']).to eq 'glicemia'
      expect(types[6]['exam_type_limits']).to eq '25-83'
      expect(types[6]['exam_type_value']).to eq '98'

      expect(types[7]['exam_type']).to eq 'tgo'
      expect(types[7]['exam_type_limits']).to eq '50-84'
      expect(types[7]['exam_type_value']).to eq '87'

      expect(types[8]['exam_type']).to eq 'tgp'
      expect(types[8]['exam_type_limits']).to eq '38-63'
      expect(types[8]['exam_type_value']).to eq '9'

      expect(types[9]['exam_type']).to eq 'eletrólitos'
      expect(types[9]['exam_type_limits']).to eq '2-68'
      expect(types[9]['exam_type_value']).to eq '85'

      expect(types[10]['exam_type']).to eq 'tsh'
      expect(types[10]['exam_type_limits']).to eq '25-80'
      expect(types[10]['exam_type_value']).to eq '65'

      expect(types[11]['exam_type']).to eq 't4-livre'
      expect(types[11]['exam_type_limits']).to eq '34-60'
      expect(types[11]['exam_type_value']).to eq '94'

      expect(types[12]['exam_type']).to eq 'ácido úrico'
      expect(types[12]['exam_type_limits']).to eq '15-61'
      expect(types[12]['exam_type_value']).to eq '2'
    end
  end

  context 'GET /all_token_info/IQCZ17' do
    it 'returns all information about an exam' do
      db = ManipulateDB.new(csv_file: './spec/support/exam_with_13_types.csv', config_file: './config/db.config',
                            scope: 'test')
      db.populate_db

      get '/all_token_info/IQCZ17'

      info = JSON.parse(last_response.body)
      expect(info['dr_crm']).to eq 'B000BJ20J4'
      expect(info['dr_state']).to eq 'PI'
      expect(info['dr_name']).to eq 'Maria Luiza Pires'
      expect(info['dr_email']).to eq 'denna@wisozk.biz'
      expect(info['token']).to eq 'IQCZ17'
      expect(info['exam_date']).to eq '2021-08-05'
    end
  end

  context 'GET /all_cpf_info/048.973.170-88' do
    it 'returns all information about a cpf' do
      db = ManipulateDB.new(csv_file: './spec/support/exam_with_13_types.csv', config_file: './config/db.config',
                            scope: 'test')
      db.populate_db

      get '/all_cpf_info/048.973.170-88'

      info = JSON.parse(last_response.body)
      expect(info['cpf']).to eq '048.973.170-88'
      expect(info['full_name']).to eq 'Emilly Batista Neto'
      expect(info['birth_date']).to eq '2001-03-11'
      expect(info['email']).to eq 'gerald.crona@ebert-quigley.com'
      expect(info['birth_date']).to eq '2001-03-11'
      expect(info['address']).to eq '165 Rua Rafaela'
      expect(info['city']).to eq 'Ituverava'
      expect(info['state']).to eq 'Alagoas'
    end
  end

  context 'GET /tests' do
    it 'returns info of all tests' do
      db = ManipulateDB.new(csv_file: './spec/support/three_people.csv', config_file: './config/db.config',
                            scope: 'test')
      db.populate_db

      get '/tests'

      info = JSON.parse(last_response.body)
      expect(info.length).to eq 3
      expect(info[0]['result_token']).to eq '0W9I67'
      expect(info[0]['result_date']).to eq '2021-07-09'
      expect(info[0]['cpf']).to eq '048.108.026-04'
      expect(info[0]['name']).to eq 'Juliana dos Reis Filho'
      expect(info[0]['email']).to eq 'mariana_crist@kutch-torp.com'
      expect(info[0]['birthday']).to eq '1995-07-03'
      expect(info[0]['doctor']['crm']).to eq 'B0002IQM66'
      expect(info[0]['doctor']['crm_state']).to eq 'SC'
      expect(info[0]['doctor']['name']).to eq 'Maria Helena Ramalho'
      expect(info[0]['tests'][0]['type']).to eq 'hemácias'
      expect(info[0]['tests'][0]['limits']).to eq '45-52'
      expect(info[0]['tests'][0]['result']).to eq '28'

      expect(info[0]['tests'][1]['type']).to eq 'leucócitos'
      expect(info[0]['tests'][1]['limits']).to eq '9-61'
      expect(info[0]['tests'][1]['result']).to eq '91'
    end
  end

  context 'GET /tests/token' do
    it 'returns info of all tests' do
      db = ManipulateDB.new(csv_file: './spec/support/three_people.csv', config_file: './config/db.config',
                            scope: 'test')
      db.populate_db

      get '/tests/0W9I67'

      info = JSON.parse(last_response.body)
      expect(info['result_token']).to eq '0W9I67'
      expect(info['result_date']).to eq '2021-07-09'
      expect(info['cpf']).to eq '048.108.026-04'
      expect(info['name']).to eq 'Juliana dos Reis Filho'
      expect(info['email']).to eq 'mariana_crist@kutch-torp.com'
      expect(info['birthday']).to eq '1995-07-03'
      expect(info['doctor']['crm']).to eq 'B0002IQM66'
      expect(info['doctor']['crm_state']).to eq 'SC'
      expect(info['doctor']['name']).to eq 'Maria Helena Ramalho'
      expect(info['tests'][0]['type']).to eq 'hemácias'
      expect(info['tests'][0]['limits']).to eq '45-52'
      expect(info['tests'][0]['result']).to eq '28'

      expect(info['tests'][1]['type']).to eq 'leucócitos'
      expect(info['tests'][1]['limits']).to eq '9-61'
      expect(info['tests'][1]['result']).to eq '91'
    end
  end
end
