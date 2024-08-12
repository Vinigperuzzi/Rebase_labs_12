require 'rspec'
require 'pg'
require 'yaml'
require_relative '../../src/manipulate_db'
require_relative '../../src/queries'

RSpec.describe Queries do
  before(:all) do
    db_config = YAML.load_file('./config/db.config')['test']
    @conn = PG.connect(dbname: db_config['database'],
                       user: db_config['username'],
                       password: db_config['password'],
                       host: db_config['host'],
                       port: db_config['port'])
    @conn.exec('DROP TABLE IF EXISTS exams')
  rescue StandardError
    puts 'Impossível conectar ao banco de dados de teste, rode o comando docker compose up -d --build para poder testar'
    exit!
  end

  after(:all) do
    @conn.exec('DROP TABLE IF EXISTS exams')
  end

  it 'and brings all cpfs existent in database (cpf_all)' do
    db = ManipulateDB.new(csv_file: './spec/support/five_cpfs.csv', config_file: './config/db.config', scope: 'test')
    db.populate_db

    dql = Queries.new(config_file: './config/db.config', scope: 'test')
    cpfs = dql.cpf_all

    expect(cpfs.length).to eq 5
    expect(cpfs[0]).to eq '048.973.170-88'
    expect(cpfs[1]).to eq '077.411.587-40'
    expect(cpfs[2]).to eq '083.892.729-70'
    expect(cpfs[3]).to eq '066.126.400-90'
    expect(cpfs[4]).to eq '089.034.562-70'
  end

  it 'and brings all tokens for a list of cpfs (all_tokens_for_cpf)' do
    db = ManipulateDB.new(csv_file: './spec/support/five_token_same_cpf.csv', config_file: './config/db.config',
                          scope: 'test')
    db.populate_db

    dql = Queries.new(config_file: './config/db.config', scope: 'test')
    tokens = dql.all_tokens_by_cpf('048.973.170-88')

    expect(tokens.length).to eq 5
    expect(tokens[0]).to eq 'IQCZ01'
    expect(tokens[1]).to eq 'IQCZ02'
    expect(tokens[2]).to eq 'IQCZ03'
    expect(tokens[3]).to eq 'IQCZ04'
    expect(tokens[4]).to eq 'IQCZ05'
  end

  it 'and brings info about the exam by token' do
    db = ManipulateDB.new(csv_file: './spec/support/exam_with_13_types.csv', config_file: './config/db.config',
                          scope: 'test')
    db.populate_db

    dql = Queries.new(config_file: './config/db.config', scope: 'test')
    info = dql.all_info_by_token('IQCZ17')
    expect(info['dr_crm']).to eq 'B000BJ20J4'
    expect(info['dr_state']).to eq 'PI'
    expect(info['dr_name']).to eq 'Maria Luiza Pires'
    expect(info['dr_email']).to eq 'denna@wisozk.biz'
    expect(info['token']).to eq 'IQCZ17'
    expect(info['exam_date']).to eq '2021-08-05'
  end

  it 'and brings info the patient by cpf' do
    db = ManipulateDB.new(csv_file: './spec/support/exam_with_13_types.csv', config_file: './config/db.config',
                          scope: 'test')
    db.populate_db

    dql = Queries.new(config_file: './config/db.config', scope: 'test')
    info = dql.all_info_by_cpf('048.973.170-88')

    expect(info['cpf']).to eq '048.973.170-88'
    expect(info['full_name']).to eq 'Emilly Batista Neto'
    expect(info['birth_date']).to eq '2001-03-11'
    expect(info['email']).to eq 'gerald.crona@ebert-quigley.com'
    expect(info['birth_date']).to eq '2001-03-11'
    expect(info['address']).to eq '165 Rua Rafaela'
    expect(info['city']).to eq 'Ituverava'
    expect(info['state']).to eq 'Alagoas'
  end

  it 'and brings all the types os exams for a given token' do
    db = ManipulateDB.new(csv_file: './spec/support/exam_with_13_types.csv', config_file: './config/db.config',
                          scope: 'test')
    db.populate_db

    dql = Queries.new(config_file: './config/db.config', scope: 'test')
    types = dql.all_exams_types_by_token('IQCZ17')

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

  it 'returns all the data as JSON' do
    db = ManipulateDB.new(csv_file: './spec/support/three_people.csv', config_file: './config/db.config', scope: 'test')
    db.populate_db

    dql = Queries.new(config_file: './config/db.config', scope: 'test')
    data = dql.tests

    expect(data).to be_an(Array)
    expect(data.length).to eq 3
    expect(data[0][:cpf]).to eq '048.108.026-04'
    expect(data[0][:name]).to eq 'Juliana dos Reis Filho'
    expect(data[0][:email]).to eq 'mariana_crist@kutch-torp.com'
    expect(data[0][:birthday]).to eq '1995-07-03'
    expect(data[0][:doctor][:crm]).to eq 'B0002IQM66'
    expect(data[0][:doctor][:crm_state]).to eq 'SC'
    expect(data[0][:doctor][:name]).to eq 'Maria Helena Ramalho'

    expect(data[0][:tests][0][:type]).to eq 'hemácias'
    expect(data[0][:tests][0][:limits]).to eq '45-52'
    expect(data[0][:tests][0][:result]).to eq '28'

    expect(data[0][:tests][1][:type]).to eq 'leucócitos'
    expect(data[0][:tests][1][:limits]).to eq '9-61'
    expect(data[0][:tests][1][:result]).to eq '91'
    
    expect(data[0][:tests][2][:type]).to eq 'plaquetas'
    expect(data[0][:tests][2][:limits]).to eq '11-93'
    expect(data[0][:tests][2][:result]).to eq '18'

    expect(data[0][:tests][3][:type]).to eq 'hdl'
    expect(data[0][:tests][3][:limits]).to eq '19-75'
    expect(data[0][:tests][3][:result]).to eq '74'

    expect(data[0][:tests][4][:type]).to eq 'ldl'
    expect(data[0][:tests][4][:limits]).to eq '45-54'
    expect(data[0][:tests][4][:result]).to eq '66'

    expect(data[0][:tests][5][:type]).to eq 'vldl'
    expect(data[0][:tests][5][:limits]).to eq '48-72'
    expect(data[0][:tests][5][:result]).to eq '41'

    expect(data[0][:tests][6][:type]).to eq 'glicemia'
    expect(data[0][:tests][6][:limits]).to eq '25-83'
    expect(data[0][:tests][6][:result]).to eq '6'

    expect(data[0][:tests][7][:type]).to eq 'tgo'
    expect(data[0][:tests][7][:limits]).to eq '50-84'
    expect(data[0][:tests][7][:result]).to eq '32'

    expect(data[0][:tests][8][:type]).to eq 'tgp'
    expect(data[0][:tests][8][:limits]).to eq '38-63'
    expect(data[0][:tests][8][:result]).to eq '16'

    expect(data[0][:tests][9][:type]).to eq 'eletrólitos'
    expect(data[0][:tests][9][:limits]).to eq '2-68'
    expect(data[0][:tests][9][:result]).to eq '61'

    expect(data[0][:tests][10][:type]).to eq 'tsh'
    expect(data[0][:tests][10][:limits]).to eq '25-80'
    expect(data[0][:tests][10][:result]).to eq '13'

    expect(data[0][:tests][11][:type]).to eq 't4-livre'
    expect(data[0][:tests][11][:limits]).to eq '34-60'
    expect(data[0][:tests][11][:result]).to eq '9'

    expect(data[0][:tests][12][:type]).to eq 'ácido úrico'
    expect(data[0][:tests][12][:limits]).to eq '15-61'
    expect(data[0][:tests][12][:result]).to eq '78'
  end
end
