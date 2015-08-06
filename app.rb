# encoding: utf-8

ROOT = File.expand_path('../', __FILE__)
$: << ROOT

require 'sinatra/base'
require 'haml'
require 'json'

require 'app/routes'

module ChatLogger
  class App < Sinatra::Base
    set :environment, ENV['RACK_ENV'].to_sym
    set :channels,    ENV['CHANNELS'].split(',')
    set :log_path,    ENV['LOG_PATH']

    configure do
      set :root,        ROOT
      set :views,       'app/views'
      set :public_dir,  ENV['ASSETS']
      set :haml, escape_html: true
    end

    configure :development, :staging do
      enable :static
      enable :logging
      enable :dump_errors
      enable :raise_errors
    end

    configure :production do
      set :haml, escape_html: true, ugly: true
    end

    register ChatLogger::Routes
  end
end
