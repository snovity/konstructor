# imitates the way requiring a built gem works
$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'korolev'

# requiring all development dependencies via Bundler,
# but not using Bundler in the runtime code
# to avoid having Bundler as runtime dependency
require 'bundler/setup'
Bundler.require(:development)
