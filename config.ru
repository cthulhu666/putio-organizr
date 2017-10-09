require_relative 'environment'
require_relative 'app/web'

use Rack::Static, urls: { '/' => 'index.html' }, root: 'public'

run WebApp
