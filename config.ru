require_relative 'environment'
require_relative 'app/web'

require 'resque/server'

use Rack::Static, urls: { '/' => 'index.html', '/done' => 'done.html' }, root: 'public'

run Rack::URLMap.new(
    '/_resque' => Resque::Server.new,
    '/' => WebApp
)
