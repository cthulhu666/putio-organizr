require_relative 'environment'
require_relative 'app/web'

use Rack::Static, urls: { '/' => 'index.html', '/done' => 'done.html' }, root: 'public'

run Rack::URLMap.new(
    '/' => WebApp
)
