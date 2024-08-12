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
    db = ManipulateDB.new(csv_file: './spec/support/three_people.csv', config_file: './config/db.config', scope: 'test')
    db.populate_db

    get '/tests'

    expect(last_response.status).to eq(200)
    data = JSON.parse(last_response.body)
    expect(data).to be_an(Array)
    expect(data.length).to eq 3
    expect(data[0]["cpf"]).to eq '048.108.026-04'
    expect(data[0]["name"]).to eq 'Juliana dos Reis Filho'
    expect(data[0]["email"]).to eq 'mariana_crist@kutch-torp.com'
    expect(data[0]["birthday"]).to eq '1995-07-03'
    expect(data[0]["doctor"]["crm"]).to eq 'B0002IQM66'
    expect(data[0]["doctor"]["crm_state"]).to eq 'SC'
    expect(data[0]["doctor"]["name"]).to eq 'Maria Helena Ramalho'

    expect(data[0]["tests"][0]["type"]).to eq 'hemácias'
    expect(data[0]["tests"][0]["limits"]).to eq '45-52'
    expect(data[0]["tests"][0]["result"]).to eq '28'

    expect(data[0]["tests"][1]["type"]).to eq 'leucócitos'
    expect(data[0]["tests"][1]["limits"]).to eq '9-61'
    expect(data[0]["tests"][1]["result"]).to eq '91'
    
    expect(data[0]["tests"][2]["type"]).to eq 'plaquetas'
    expect(data[0]["tests"][2]["limits"]).to eq '11-93'
    expect(data[0]["tests"][2]["result"]).to eq '18'

    expect(data[0]["tests"][3]["type"]).to eq 'hdl'
    expect(data[0]["tests"][3]["limits"]).to eq '19-75'
    expect(data[0]["tests"][3]["result"]).to eq '74'

    expect(data[0]["tests"][4]["type"]).to eq 'ldl'
    expect(data[0]["tests"][4]["limits"]).to eq '45-54'
    expect(data[0]["tests"][4]["result"]).to eq '66'

    expect(data[0]["tests"][5]["type"]).to eq 'vldl'
    expect(data[0]["tests"][5]["limits"]).to eq '48-72'
    expect(data[0]["tests"][5]["result"]).to eq '41'

    expect(data[0]["tests"][6]["type"]).to eq 'glicemia'
    expect(data[0]["tests"][6]["limits"]).to eq '25-83'
    expect(data[0]["tests"][6]["result"]).to eq '6'

    expect(data[0]["tests"][7]["type"]).to eq 'tgo'
    expect(data[0]["tests"][7]["limits"]).to eq '50-84'
    expect(data[0]["tests"][7]["result"]).to eq '32'

    expect(data[0]["tests"][8]["type"]).to eq 'tgp'
    expect(data[0]["tests"][8]["limits"]).to eq '38-63'
    expect(data[0]["tests"][8]["result"]).to eq '16'

    expect(data[0]["tests"][9]["type"]).to eq 'eletrólitos'
    expect(data[0]["tests"][9]["limits"]).to eq '2-68'
    expect(data[0]["tests"][9]["result"]).to eq '61'

    expect(data[0]["tests"][10]["type"]).to eq 'tsh'
    expect(data[0]["tests"][10]["limits"]).to eq '25-80'
    expect(data[0]["tests"][10]["result"]).to eq '13'

    expect(data[0]["tests"][11]["type"]).to eq 't4-livre'
    expect(data[0]["tests"][11]["limits"]).to eq '34-60'
    expect(data[0]["tests"][11]["result"]).to eq '9'

    expect(data[0]["tests"][12]["type"]).to eq 'ácido úrico'
    expect(data[0]["tests"][12]["limits"]).to eq '15-61'
    expect(data[0]["tests"][12]["result"]).to eq '78'
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
