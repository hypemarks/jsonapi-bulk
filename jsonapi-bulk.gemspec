# -*- encoding: utf-8 -*-
$:.push File.expand_path('../lib', __FILE__)
require 'jsonapi/bulk/version'

Gem::Specification.new do |spec|
  spec.name = 'jsonapi-bulk'
  spec.version = JSONAPI::Bulk::VERSION
  spec.author = ['Francois Deschenes']
  spec.email = ['fdeschenes@me.com']
  spec.summary = ''
  spec.description = ''
  spec.homepage = 'https://github.com/hypemarks/jsonapi-bulk'
  spec.license = 'MIT'

  spec.files = Dir['LICENSE', 'README.md', 'lib/**/*']
  spec.require_path = 'lib'

  spec.add_dependency 'jsonapi-rb', '~> 0.5.0'
  spec.add_dependency 'jsonapi-parser', '~> 0.1.0'
  
  spec.add_development_dependency 'rails', '~> 5.0'
end
