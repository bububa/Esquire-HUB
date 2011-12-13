# This file is used by Rack-based servers to start the application.

require ::File.expand_path('../config/environment',  __FILE__)
require 'rack/contrib'
use Rack::StaticCache, :urls => [ '/assets',  ], :root => 'public'
run Esquire::Application
