require 'sidekiq'
require 'tempfile'
require './src/manipulate_db'

class CsvImportWorker
  include Sidekiq::Worker

  def perform(file_content, config_file, scope)
    Tempfile.create(['uploaded', '.csv']) do |tempfile|
      tempfile.write(file_content)
      tempfile.rewind
      db = ManipulateDB.new(csv_file: tempfile.path, config_file: config_file, scope: scope)
      db.populate_db
    end
  end
end
