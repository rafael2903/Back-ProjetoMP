# frozen_string_literal: true

Apipie.configure do |config|
  config.app_name                = 'ProjetoMp'
  config.api_base_url            = 'localhost:3000'
  config.doc_base_url            = '/documentation'
  # where is your API defined?
  config.api_controllers_matcher = "#{Rails.root}/app/controllers/**/*.rb"
  config.translate = false
  config.validate = false
end
