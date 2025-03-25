// Entry point for the build script in your package.json
import '@hotwired/turbo-rails'
Turbo.session.drive = false
import './controllers'

import * as bootstrap from 'bootstrap'
window.bootstrap = bootstrap

import Rails from '@rails/ujs'
Rails.start()
