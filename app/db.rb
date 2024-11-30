# frozen_string_literal: true

require 'sequel'

Sequel::Model.raise_on_save_failure = false # Do not throw exceptions on failure

DATABASE_URL = case ENV['RACK_ENV'].to_sym
               when :test
                 ENV['TEST_DB_URL'] || 'postgres://postgres:postgres@localhost/webapi_template_test'
               when :development
                 ENV['DEV_DB_URL'] || 'postgres://postgres:postgres@localhost/webapi_template_development'
               else
                 'sqlite://db/development.sqlite3'
               end

DB = Sequel.connect(DATABASE_URL)

DB.create_table? :products do
  primary_key :id
  String :name
  Integer :value
end

DB.create_table? :users do
  primary_key :id
  String :username, unique: true, null: false
  String :password_digest, null: false
end

# Seeds (opcional)
DB[:products].insert(name: 'Linterna', value: 100) if DB[:products].count.zero?
