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

$LOAD_PATH.unshift "./lib"

require 'rubygems'
require 'rake'
require 'rake/packagetask'
require 'rake/gempackagetask'
require 'rake/rdoctask'
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
  s.email = 'mutoh@highway.ne.jp'
  s.homepage = 'http://gettext.rubyforge.org/'
  s.rubyforge_project = "gettext"
  s.files = FileList['**/*'].to_a.select{|v| v !~ /pkg|git/}
  s.require_path = 'lib'
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
  rdoc.rdoc_files.include('README', 'ChangeLog')
  rdoc.rdoc_files.include('lib/**/*.rb')
  rdoc.template = allison if allison.size > 0
}

desc "Publish the release files to RubyForge."
task :release => [ :package ] do
  require 'rubyforge'

  rubyforge = RubyForge.new
  rubyforge.login
  rubyforge.add_release("gettext_activerecord", "gettext_activerecord", 
                        "gettext_activerecord #{PKG_VERSION}", 
                        "pkg/gettext_activerecord-#{PKG_VERSION}.gem",
                        "pkg/gettext_activerecord-#{PKG_VERSION}.tar.gz")
end

