require 'sidekiq/testing'
require 'tempfile'
require 'rspec'
require './src/manipulate_db'
require './lib/workers/csv_import_worker'

RSpec.describe CsvImportWorker, type: :worker do
  before do
    Sidekiq::Testing.fake!
  end

  it 'processes the CSV file assinchronously and populates the database' do
    config_file = './config/db.config'
    scope = 'test'
    file_content = File.read('./public/csv/data2.csv')
    CsvImportWorker.perform_async(file_content, config_file, scope)

    expect(CsvImportWorker.jobs.size).to eq(1)
    job = CsvImportWorker.jobs.first
    expect(job['args']).to eq([file_content, config_file, scope])

    CsvImportWorker.drain

    db_config = YAML.load_file(config_file)['test']
    @conn = PG.connect(dbname: db_config['database'],
                       user: db_config['username'],
                       password: db_config['password'],
                       host: db_config['host'],
                       port: db_config['port'])

    result = @conn.exec('SELECT * FROM exams')
    expect(result.ntuples).to be 39
  end
end
