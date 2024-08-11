require 'rspec'
require 'pg'
require 'yaml'
require_relative '../../src/manipulate_db'
require_relative '../../src/queries.rb'

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
    expect(cpfs[0]).to eq '077.411.587-40'
    expect(cpfs[1]).to eq '066.126.400-90'
    expect(cpfs[2]).to eq '089.034.562-70'
    expect(cpfs[3]).to eq '083.892.729-70'
    expect(cpfs[4]).to eq '048.973.170-88'
  end

  it 'and brings all tokens for a list of cpfs (all_tokens_for_cpf)' do
    db = ManipulateDB.new(csv_file: './spec/support/five_token_same_cpf.csv', config_file: './config/db.config', scope: 'test')
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
    db = ManipulateDB.new(csv_file: './spec/support/exam_with_13_types.csv', config_file: './config/db.config', scope: 'test')
    db.populate_db

    dql = Queries.new(config_file: './config/db.config', scope: 'test')
    info = dql.all_info_by_token('IQCZ17')

    expect(info['cpf']).to eq '048.973.170-88'
    expect(info['full_name']).to eq 'Emilly Batista Neto'
    expect(info['birth_date']).to eq '2001-03-11'
    expect(info['email']).to eq 'gerald.crona@ebert-quigley.com'
    expect(info['birth_date']).to eq '2001-03-11'
    expect(info['address']).to eq '165 Rua Rafaela'
    expect(info['city']).to eq 'Ituverava'
    expect(info['state']).to eq 'Alagoas'
    expect(info['dr_crm']).to eq 'B000BJ20J4'
    expect(info['dr_state']).to eq 'PI'
    expect(info['dr_name']).to eq 'Maria Luiza Pires'
    expect(info['dr_email']).to eq 'denna@wisozk.biz'
    expect(info['token']).to eq 'IQCZ17'
    expect(info['exam_date']).to eq '2021-08-05'
  end
end