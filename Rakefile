#
# Rakefile for gettext_activerecord.
#
# Use setup.rb or gem for installation.
# You don't need to use this file directly.
#
# Copyright(c) 2009 Masao Mutoh
#
# This program is licenced under the same licence as Ruby.
#

#make lib and paralel gettext checkout available
$LOAD_PATH.unshift "./lib"
gettext_path = File.join(ENV["GETTEXT_PATH"] || "../gettext/", "lib")
$LOAD_PATH.unshift gettext_path

require 'rubygems'
require 'rake'
require 'rake/packagetask'
require 'rake/gempackagetask'
require 'rake/rdoctask'

gettext_path = File.join(ENV["GETTEXT_PATH"] || "../gettext/", "lib")
$LOAD_PATH.unshift gettext_path

require 'gettext_activerecord/version'

PKG_VERSION = GetTextActiveRecord::VERSION

task :default => [:makemo]

############################################################
# Manage po/mo files
############################################################
desc "Create *.mo from *.po"
task :makemo do
  $stderr.puts "Create active_record mo files."
  require 'gettext/tools'
  GetText.create_mofiles
end

desc "Update pot/po files to match new version."
task :updatepo do
  require 'gettext/tools'

  GetText.update_pofiles("gettext_activerecord", 
			 Dir.glob("lib/**/*.rb"),
			 "gettext_activerecord #{PKG_VERSION}")

end

############################################################
# Package tasks
############################################################

desc "Create gem and tar.gz"
spec = Gem::Specification.new do |s|
  s.name = 'gettext_activerecord'
  s.version = PKG_VERSION
  s.summary = 'Localization support for ActiveRecord by Ruby-GetText-Package.'
  s.author = 'Masao Mutoh'
  s.email = 'mutomasa at gmail.com'
  s.homepage = 'http://gettext.rubyforge.org/'
  s.rubyforge_project = "gettext"
  s.files = FileList['**/*'].to_a.select{|v| v !~ /pkg|git/}
  s.require_path = 'lib'
  s.add_dependency('gettext', '>= 2.0.4')
  s.add_dependency('activerecord', '>= 2.3.2')
  s.has_rdoc = true
  s.description = 'Localization support for ActiveRecord by Ruby-GetText-Package.'
end

Rake::PackageTask.new("gettext_activerecord", PKG_VERSION) do |o|
  o.package_files = FileList['**/*'].to_a.select{|v| v !~ /pkg|git/}
  o.need_tar_gz = true
  o.need_zip = false
end

Rake::GemPackageTask.new(spec) do |p|
  p.gem_spec = spec
  p.need_tar_gz = false
  p.need_zip = false
end

############################################################
# Misc tasks
############################################################

Rake::RDocTask.new { |rdoc|
  allison = `allison --path`.chop
  rdoc.rdoc_dir = 'doc'
  rdoc.title    = "gettext_activerecord API Reference"
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README.rdoc', 'ChangeLog')
  rdoc.rdoc_files.include('lib/**/*.rb')
  rdoc.template = allison if allison.size > 0
}

desc "Publish the release files to RubyForge."
task :release => [:makemo, :package ] do
  require 'rubyforge'

  rubyforge = RubyForge.new
  rubyforge.configure
  rubyforge.login
  rubyforge.add_release("gettext", "gettext_activerecord", 
                        PKG_VERSION, 
                        "pkg/gettext_activerecord-#{PKG_VERSION}.gem",
                        "pkg/gettext_activerecord-#{PKG_VERSION}.tar.gz")
end

# Run the unit tests
desc 'Run tests'
task :test do
  cd "test"
  Dir.glob("test_*.rb").each do |v|
    ruby "-Ilib:../../locale/lib:../../gettext/lib #{v}"
  end
  cd ".."
end
