load 'lib/omai5/VERSION'
Gem::Specification.new do |s|
  s.name = 'omai5'
  s.version = Omai5::VERSION
  s.date = Time.now.to_s.split(' ')[0]
  s.summary = 'Library to read Chum5/Chummer5 Files'
  s.add_runtime_dependency 'nokogiri', '~> 1.8'
  s.add_runtime_dependency 'octokit', '~> 4.0'
  s.add_runtime_dependency 'rubysl-base64', '~> 2.0'
  s.authors = ['Nora Maguire']
  s.email = 'eva@rigel.moe'
  s.require_paths = %w[lib lib/omai5]
  s.files = ['README.md','lib/omai5.rb']
  s.files.concat(Dir['lib/omai5/*'])
  s.homepage = "http://rubygems.org/gems/#{s.name}"
  s.license = 'MIT'
end
