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

describe 'GET /tests' do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  it 'returns all the data as JSON' do
    db = ManipulateDB.new(csv_file: './spec/support/test.csv', config_file: './config/db.config', scope: 'test')
    db.populate_db

    get '/tests'

    expect(last_response.status).to eq(200)
    data = JSON.parse(last_response.body)
    expect(data).to be_an(Array)
    expect(data.length).to eq 3
    expect(data[0]['cpf']).to eq '048.973.170-88'
    expect(data[0]['full_name']).to eq 'Emilly Batista Neto'
    expect(data[0]['email']).to eq 'gerald.crona@ebert-quigley.com'
    expect(data[0]['birth_date']).to eq '2001-03-11'
    expect(data[0]['address']).to eq '165 Rua Rafaela'
    expect(data[0]['city']).to eq 'Ituverava'
    expect(data[0]['state']).to eq 'Alagoas'
    expect(data[0]['dr_crm']).to eq 'B000BJ20J4'
    expect(data[0]['dr_state']).to eq 'PI'
    expect(data[0]['dr_name']).to eq 'Maria Luiza Pires'
    expect(data[0]['dr_email']).to eq 'denna@wisozk.biz'
    expect(data[0]['token']).to eq 'IQCZ17'
    expect(data[0]['exam_date']).to eq '2021-08-05'
    expect(data[0]['exam_type']).to eq 'hemácias'
    expect(data[0]['exam_type_limits']).to eq '45-52'
    expect(data[0]['exam_type_value']).to eq '97'
    expect(data[1]['exam_type']).to eq 'leucócitos'
    expect(data[1]['exam_type_limits']).to eq '9-61'
    expect(data[1]['exam_type_value']).to eq '89'
    expect(data[2]['exam_type']).to eq 'plaquetas'
    expect(data[2]['exam_type_limits']).to eq '11-93'
    expect(data[2]['exam_type_value']).to eq '97'

  end

  it "and there's no data" do
    conn = instance_double('PG::Connection')
    allow(conn).to receive(:exec).and_raise(PG::Error.new('inexistent table in DB'))
    allow(PG).to receive(:connect).and_return(conn)

    get '/tests'

    expect(last_response.status).to eq(200)
    expect(last_response.body).to eq 'Não há dados a serem exibidos, ou o não foi possível conectar ao banco'
  end
end
