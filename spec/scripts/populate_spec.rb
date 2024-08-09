require 'rspec'
require 'pg'
require 'yaml'
require_relative '../../src/manipulate_db.rb'

RSpec.describe ManipulateDB do
    before(:all) do
      @db_config = YAML.load_file('./config/db.config')['test']
      @db = ManipulateDB.new(csv_file: './spec/support/test.csv', config_file: './config/db.config', scope: 'test')
      @conn = PG.connect( dbname: @db_config['database'],
                         user: @db_config['username'],
                         password: @db_config['password'],
                         host: @db_config['host'],
                         port: @db_config['port']
                        )
      @conn.exec('DROP TABLE IF EXISTS exams')
    rescue
      exit!
    end

    after(:all) do
      @conn.exec('DROP TABLE IF EXISTS exams')
    end

  it 'populates the database with data from the csv file' do
    @db.populate_db

    result = @conn.exec("SELECT * FROM exams")
    
    first_row = result[0]
    second_row = result[1]
    third_row = result[2]
    
    expect(result.ntuples).to eq 3
    expect(first_row['cpf']).to eq '048.973.170-88'
    expect(second_row['cpf']).to eq '048.973.170-88'
    expect(third_row['cpf']).to eq '048.973.170-88'
    expect(first_row['full_name']).to eq 'Emilly Batista Neto'
    expect(first_row['email']).to eq 'gerald.crona@ebert-quigley.com'
    expect(first_row['birth_date']).to eq '2001-03-11'
    expect(first_row['address']).to eq '165 Rua Rafaela'
    expect(first_row['city']).to eq 'Ituverava'
    expect(first_row['state']).to eq 'Alagoas'
    expect(first_row['dr_crm']).to eq 'B000BJ20J4'
    expect(first_row['dr_state']).to eq 'PI'
    expect(first_row['dr_name']).to eq 'Maria Luiza Pires'
    expect(first_row['dr_email']).to eq 'denna@wisozk.biz'
    expect(first_row['token']).to eq 'IQCZ17'
    expect(first_row['exam_date']).to eq '2021-08-05'
    expect(first_row['exam_type']).to eq 'hemácias'
    expect(first_row['exam_type_limits']).to eq '45-52'
    expect(first_row['exam_type_value']).to eq '97'
  end

  it 'and drop everithing' do
    @db.populate_db
    @db.drop_exams

    result = @conn.exec("SELECT table_name \
                         FROM information_schema.tables \
                         WHERE table_schema = 'public' \
                         AND table_type = 'BASE TABLE';")

    expect(result.ntuples).to eq 0
  end
end