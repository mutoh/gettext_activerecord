require 'helper'

require 'gettext_activerecord/tools'

GetText::ActiveRecordParser.init(
                                 :adapter  => "mysql",
                                 :username => "root",
                                 :password => "",
                                 :encoding => "utf8",
                                 :socket => "/var/lib/mysql/mysql.sock",
                                 :database => 'activerecord_unittest'
                                 )

class TestGetTextParser < Test::Unit::TestCase
  def test_class
    GetText::ActiveRecordParser.target?("fixtures/topic.rb")
    ary = GetText::ActiveRecordParser.parse("fixtures/topic.rb")
    assert_equal(14, ary.size)
    assert_equal(["topic", "fixtures/topic.rb:-"], ary[0])
    assert_equal(["Topic|Title", "fixtures/topic.rb:-"], ary[1])
    assert_equal(["Topic|Author name", "fixtures/topic.rb:-"], ary[2])
    assert_equal(["Topic|Author email address", "fixtures/topic.rb:-"], ary[3])
    assert_equal(["Topic|Written on", "fixtures/topic.rb:-"], ary[4])
    assert_equal(["Topic|Bonus time", "fixtures/topic.rb:-"], ary[5])
    assert_equal(["Topic|Last read", "fixtures/topic.rb:-"], ary[6])
    assert_equal(["Topic|Content", "fixtures/topic.rb:-"], ary[7])
    assert_equal(["Topic|Approved", "fixtures/topic.rb:-"], ary[8])
    assert_equal(["Topic|Replies count", "fixtures/topic.rb:-"], ary[9])
    assert_equal(["Topic|Parent", "fixtures/topic.rb:-"], ary[10])
    assert_equal(["Topic|Type", "fixtures/topic.rb:-"], ary[11])
    assert_equal(["Topic|Terms of service", "fixtures/topic.rb:35"], ary[12])
    assert_equal(["must be abided", "fixtures/topic.rb:36"], ary[13])
  end

  def test_subclass
    GetText::ActiveRecordParser.target?("fixtures/reply.rb")
    ary = GetText::ActiveRecordParser.parse("fixtures/reply.rb")
    ary.sort!{|a, b| a[0].downcase <=> b[0].downcase}

    assert_equal(30, ary.size)
    assert_equal(["Empty", "fixtures/reply.rb:16", "fixtures/reply.rb:20"], ary[0])
    assert_equal(["is Content Mismatch", "fixtures/reply.rb:25"], ary[1])
    assert_equal(["is Wrong Create", "fixtures/reply.rb:30"], ary[2])
    assert_equal(["is Wrong Update", "fixtures/reply.rb:34"], ary[3])
    assert_equal(["reply", "fixtures/reply.rb:-"], ary[4])
    assert_equal(["Reply|Approved", "fixtures/reply.rb:-"], ary[5])
    assert_equal(["Reply|Author email address", "fixtures/reply.rb:-"], ary[6])
    assert_equal(["Reply|Author name", "fixtures/reply.rb:-"], ary[7])
    assert_equal(["Reply|Bonus time", "fixtures/reply.rb:-"], ary[8])
    assert_equal(["Reply|Content", "fixtures/reply.rb:-"], ary[9])
    assert_equal(["Reply|Last read", "fixtures/reply.rb:-"], ary[10])
    assert_equal(["Reply|Parent", "fixtures/reply.rb:-"], ary[11])
    assert_equal(["Reply|Replies count", "fixtures/reply.rb:-"], ary[12])
    assert_equal(["Reply|Title", "fixtures/reply.rb:-"], ary[13])
    assert_equal(["Reply|Topic", "fixtures/reply.rb:4"], ary[14])
    assert_equal(["Reply|Type", "fixtures/reply.rb:-"], ary[15])
    assert_equal(["Reply|Written on", "fixtures/reply.rb:-"], ary[16])

    assert_equal(["sillyreply", "fixtures/reply.rb:-"], ary[17])
    assert_equal(["SillyReply|Approved", "fixtures/reply.rb:-"], ary[18])
    assert_equal(["SillyReply|Author email address", "fixtures/reply.rb:-"], ary[19])
    assert_equal(["SillyReply|Author name", "fixtures/reply.rb:-"], ary[20])
    assert_equal(["SillyReply|Bonus time", "fixtures/reply.rb:-"], ary[21])
    assert_equal(["SillyReply|Content", "fixtures/reply.rb:-"], ary[22])
    assert_equal(["SillyReply|Last read", "fixtures/reply.rb:-"], ary[23])
    assert_equal(["SillyReply|Parent", "fixtures/reply.rb:-"], ary[24])
    assert_equal(["SillyReply|Replies count", "fixtures/reply.rb:-"], ary[25])
    assert_equal(["SillyReply|Title", "fixtures/reply.rb:-"], ary[26])
    assert_equal(["SillyReply|Type", "fixtures/reply.rb:-"], ary[27])
    assert_equal(["SillyReply|Written on", "fixtures/reply.rb:-"], ary[28])

    assert_equal(["topic", "fixtures/reply.rb:-"], ary[29])
  end

  def test_untranslate
    GetText::ActiveRecordParser.target?("fixtures/book.rb")
    ary = GetText::ActiveRecordParser.parse("fixtures/book.rb")
    ary.sort!{|a, b| a[0].downcase <=> b[0].downcase}
    assert_equal(4, ary.size)
    assert_equal(["book", "fixtures/book.rb:-"], ary[0])
    assert_equal(["Book|Created at", "fixtures/book.rb:-"], ary[1])
    assert_equal(["Book|Price", "fixtures/book.rb:-"], ary[2])
    assert_equal(["Book|Updated at", "fixtures/book.rb:-"], ary[3])
  end

  def test_untranslate_all
    GetText::ActiveRecordParser.target?("fixtures/user.rb")
    ary = GetText::ActiveRecordParser.parse("fixtures/user.rb")
    assert_equal(0, ary.size)
  end

  def test_abstract_class
    ary = GetText::ActiveRecordParser.parse("fixtures/wizard.rb")
    assert_equal(0, ary.size)
  end
end
