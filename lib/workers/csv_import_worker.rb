require 'sidekiq'
require_relative '../../src/manipulate_db'

class CsvImportWorker
  include Sidekiq::Worker

  def perform(file_path)
    db = ManipulateDB.new(csv_file: file_path, config_file: '../../config/db.config', scope: 'container')
    db.populate_db
  end
end