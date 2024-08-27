# frozen_string_literal: true

require_relative 'lib/gitolite/version'

Gem::Specification.new do |s|
  s.name        = 'gitolite-rugged'
  s.version     = Gitolite::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Oliver Günther']
  s.email       = ['mail@oliverguenther.de']
  s.homepage    = 'https://github.com/oliverguenther/gitolite-rugged'
  s.summary     = 'A Ruby gem for manipulating the Gitolite Git backend via the gitolite-admin repository.'
  s.description = 'This gem is designed to provide a Ruby interface to the Gitolite Git backend system using libgit2/rugged. This gem aims to provide all management functionality that is available via the gitolite-admin repository (like SSH keys, repository permissions, etc)'
  s.license     = 'MIT'

  s.required_ruby_version = '>= 2.7.0'

  s.files = `git ls-files`.split("\n")

  s.add_dependency 'gratr19', '~> 0.4.4', '>= 0.4.4.1'
  s.add_dependency 'rugged',  '~> 1.5.0'
  s.add_dependency 'zeitwerk'
end
