require 'sidekiq'
require 'yaml'
require_relative '../../src/manipulate_db'

class CsvImportWorker
  include Sidekiq::Worker

  def perform(file_path, config_file, scope)
    db_config = YAML.load_file(config_file)[scope]
    db = ManipulateDB.new(csv_file: file_path, config_file: config_file, scope: scope)
    db.populate_db
  end
end
