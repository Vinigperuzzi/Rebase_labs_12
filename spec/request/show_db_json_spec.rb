require 'rack/test'
require 'rspec'
require_relative '../../server'

ENV['RACK_ENV'] = 'test'

describe 'GET /tests' do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  it 'returns all the data as JSON' do
    get '/tests'

    expect(last_response.status).to eq(200)

    data = JSON.parse(last_response.body)
    expect(data).to be_an(Array)
    expect(data.length).to eq 3900
    expect(data[0]['cpf']).to eq '048.973.170-88'
    expect(data[0]['full_name']).to eq 'Emilly Batista Neto'
    expect(data[3899]['cpf']).to eq '071.488.453-78'
    expect(data[3899]['full_name']).to eq 'Antônio Rebouças'
  end
end
