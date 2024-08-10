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

  it 'and bring all cpfs existent in database (cpf_all)' do
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

  it 'and bring all tokens for a list of cpfs (all_token_for_cpf)' do
    db = ManipulateDB.new(csv_file: './spec/support/five_cpfs.csv', config_file: './config/db.config', scope: 'test')
    db.populate_db

    dql = Queries.new(config_file: './config/db.config', scope: 'test')
    cpfs = dql.cpf_all
  end
end