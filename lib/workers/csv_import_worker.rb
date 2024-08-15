require 'sidekiq'
require 'yaml'
require_relative '../../src/manipulate_db'

class CsvImportWorker
  include Sidekiq::Worker

  def perform(file_path, config_file, scope)
    puts("\n\n\n\n\nArquivo = #{file_path}")
    puts("Config = #{config_file}")
    puts("scope = #{scope}\n\n\n\n\n")
    db_config = YAML.load_file(config_file)[scope]
    db = ManipulateDB.new(csv_file: file_path, config_file: db_config, scope: scope)
    db.populate_db
  end
end
