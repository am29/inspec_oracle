Gem::Specification.new do |spec|
  spec.name        = 'inspec-oracle'
  spec.version     = '0.0.1'
  spec.homepage    = 'https://github.com/enterprisemodules/inspec-oracle'
  spec.license     = ''
  spec.author      = 'Bert Hajee'
  spec.email       = 'bert.hajee@enterprisemodules.com'
  spec.files       = Dir[
    'README.md',
    'LICENSE',
    'lib/**/*',
    'oracle/**/*',
    'spec/**/*',
  ]
  spec.test_files  = Dir['spec/**/*']
  spec.summary     = 'Inspec Library to test Oracle settings'
  spec.description = <<-EOF
    Inspec Library to test Oracle settings
  EOF

  spec.add_dependency             'inspec', '~> 0.16.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rspec-its', '~> 1.0'
  spec.add_development_dependency 'rspec-collection_matchers', '~> 1.0'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rubygems-tasks'
end
