# -*- encoding: utf-8 -*-
#require 'rake'

Dir.chdir("test") do
  Rake.application['makemo'].invoke
end

Gem::Specification.new do |s|
  s.name = %q{gettext_activerecord}
  s.version = "2.0.4"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Masao Mutoh"]
  s.date = %q{2009-08-20}
  s.description = %q{Localization support for ActiveRecord by Ruby-GetText-Package.}
  s.email = %q{mutomasa at gmail.com}
  s.files = ["ChangeLog", "po/hr/gettext_activerecord.po", "po/cs/gettext_activerecord.po", "po/vi/gettext_activerecord.po", "po/nb/gettext_activerecord.po", "po/nl/gettext_activerecord.po", "po/zh/gettext_activerecord.po", "po/el/gettext_activerecord.po", "po/ko/gettext_activerecord.po", "po/gettext_activerecord.pot", "po/de/gettext_activerecord.po", "po/lv/gettext_activerecord.po", "po/hu/gettext_activerecord.po", "po/ja/gettext_activerecord.po", "po/eo/gettext_activerecord.po", "po/sr/gettext_activerecord.po", "po/es/gettext_activerecord.po", "po/bg/gettext_activerecord.po", "po/ca/gettext_activerecord.po", "po/bs/gettext_activerecord.po", "po/it/gettext_activerecord.po", "po/pt_BR/gettext_activerecord.po", "po/ua/gettext_activerecord.po", "po/ru/gettext_activerecord.po", "po/zh_TW/gettext_activerecord.po", "po/fr/gettext_activerecord.po", "po/et/gettext_activerecord.po", "sample/po/ja/sample_ar.po", "sample/po/sample_ar.pot", "sample/README.rdoc", "sample/Rakefile", "sample/sample.rb", "sample/config/database.yml", "sample/db/schema.rb", "sample/book.rb", "README.rdoc", "COPYING", "Rakefile", "lib/gettext_activerecord.rb", "lib/gettext_activerecord/migration.rb", "lib/gettext_activerecord/i18n.rb", "lib/gettext_activerecord/validations.rb", "lib/gettext_activerecord/schema_definitions.rb", "lib/gettext_activerecord/parser.rb", "lib/gettext_activerecord/version.rb", "lib/gettext_activerecord/base.rb", "lib/gettext_activerecord/tools.rb", "test/locale/ja/LC_MESSAGES/active_record.mo", "test/po/ja/active_record.po", "test/po/active_record.pot", "test/helper.rb", "test/vendor/repair_helper.rb", "test/Rakefile", "test/models/developer.rb", "test/models/wizard.rb", "test/models/reply.rb", "test/models/inept_wizard.rb", "test/models/topic.rb", "test/models/book.rb", "test/models/user.rb", "test/test_parser.rb", "test/test_validations.rb", "test/db/migrate.rb", "test/db/sqlite.rb"]
  s.homepage = %q{http://gettext.rubyforge.org/}
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{gettext}
  s.rubygems_version = %q{1.3.4}
  s.summary = %q{Localization support for ActiveRecord by Ruby-GetText-Package.}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<gettext>, [">= 2.0.4"])
      s.add_runtime_dependency(%q<activerecord>, [">= 2.3.2"])
    else
      s.add_dependency(%q<gettext>, [">= 2.0.4"])
      s.add_dependency(%q<activerecord>, [">= 2.3.2"])
    end
  else
    s.add_dependency(%q<gettext>, [">= 2.0.4"])
    s.add_dependency(%q<activerecord>, [">= 2.3.2"])
  end
end
