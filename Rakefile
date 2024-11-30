# frozen_string_literal: true

require 'bundler/setup'
require 'rake'
require 'rspec/core/rake_task'
require 'rubocop/rake_task'
require 'English'

ENV['RACK_ENV'] ||= 'test'
RACK_ENV = ENV['RACK_ENV'] || 'test' unless defined?(RACK_ENV)

namespace :test do
  desc 'Run all tests'
  task :all do
    %w[rubocop spec].each do |cmd|
      puts "Starting to run #{cmd}..."
      success = system("export DISPLAY=:99.0 && bundle exec rake #{cmd}")
      raise "#{cmd} failed!" unless success && $CHILD_STATUS.exitstatus.zero?
    end
  end
end

RSpec::Core::RakeTask.new(:spec) do |t|
  t.pattern = './spec/**/*_spec.rb'
end

Rake::Task.define_task(:db) do
  desc 'Run database migrations'
  task :migrate do
    # Ensure run migrations
  end
end

RSpec::Core::RakeTask.new(:spec_report) do |t|
  t.pattern = './spec/**/*_spec.rb'
  t.rspec_opts = %w[--format RspecJunitFormatter --out reports/spec/spec.xml]
end

RuboCop::RakeTask.new(:rubocop) do |task|
  task.requires << 'rubocop-rspec'
  task.fail_on_error = false
end

task default: 'test:all'
