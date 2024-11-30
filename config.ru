# frozen_string_literal: true

require './app/app'

use Rack::Static,
    urls: ['/AUTHORS'],
    root: 'public',
    header_rules: [
      [:all, { 'Cache-Control' => 'public, max-age=86400' }]
    ]

run MainApp
