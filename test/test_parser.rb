require 'helper'

require 'gettext_activerecord/tools'

class TestGetTextParser < Test::Unit::TestCase
  def assert_parser(ary, po)
    poary = [po.msgid, *po.sources]
    assert_equal(ary, poary)
  end

  def test_class
    ary = GetText::RGetText.parse("models/topic.rb")
    assert_equal(14, ary.size)
    assert_parser(["topic", "models/topic.rb:-"], ary[0])
    assert_parser(["Topic|Title", "models/topic.rb:-"], ary[1])
    assert_parser(["Topic|Author name", "models/topic.rb:-"], ary[2])
    assert_parser(["Topic|Author email address", "models/topic.rb:-"], ary[3])
    assert_parser(["Topic|Written on", "models/topic.rb:-"], ary[4])
    assert_parser(["Topic|Bonus time", "models/topic.rb:-"], ary[5])
    assert_parser(["Topic|Last read", "models/topic.rb:-"], ary[6])
    assert_parser(["Topic|Content", "models/topic.rb:-"], ary[7])
    assert_parser(["Topic|Approved", "models/topic.rb:-"], ary[8])
    assert_parser(["Topic|Replies count", "models/topic.rb:-"], ary[9])
    assert_parser(["Topic|Parent", "models/topic.rb:-"], ary[10])
    assert_parser(["Topic|Type", "models/topic.rb:-"], ary[11])
    assert_parser(["Topic|Terms of service", "models/topic.rb:35"], ary[12])
    assert_parser(["must be abided", "models/topic.rb:36"], ary[13])
  end

  def test_subclass
    ary = GetText::RGetText.parse("models/reply.rb")
    ary.sort!{|a, b| a[0].downcase <=> b[0].downcase}

    assert_equal(30, ary.size)
    assert_parser(["Empty", "models/reply.rb:16", "models/reply.rb:20"], ary[0])
    assert_parser(["is Content Mismatch", "models/reply.rb:25"], ary[1])
    assert_parser(["is Wrong Create", "models/reply.rb:30"], ary[2])
    assert_parser(["is Wrong Update", "models/reply.rb:34"], ary[3])
    assert_parser(["reply", "models/reply.rb:-"], ary[4])
    assert_parser(["Reply|Approved", "models/reply.rb:-"], ary[5])
    assert_parser(["Reply|Author email address", "models/reply.rb:-"], ary[6])
    assert_parser(["Reply|Author name", "models/reply.rb:-"], ary[7])
    assert_parser(["Reply|Bonus time", "models/reply.rb:-"], ary[8])
    assert_parser(["Reply|Content", "models/reply.rb:-"], ary[9])
    assert_parser(["Reply|Last read", "models/reply.rb:-"], ary[10])
    assert_parser(["Reply|Parent", "models/reply.rb:-"], ary[11])
    assert_parser(["Reply|Replies count", "models/reply.rb:-"], ary[12])
    assert_parser(["Reply|Title", "models/reply.rb:-"], ary[13])
    # this target is from N_().
    assert_parser(["Reply|Topic", "models/reply.rb:4"], ary[14])
    assert_parser(["Reply|Type", "models/reply.rb:-"], ary[15])
    assert_parser(["Reply|Written on", "models/reply.rb:-"], ary[16])

    assert_parser(["sillyreply", "models/reply.rb:-"], ary[17])
    assert_parser(["SillyReply|Approved", "models/reply.rb:-"], ary[18])
    assert_parser(["SillyReply|Author email address", "models/reply.rb:-"], ary[19])
    assert_parser(["SillyReply|Author name", "models/reply.rb:-"], ary[20])
    assert_parser(["SillyReply|Bonus time", "models/reply.rb:-"], ary[21])
    assert_parser(["SillyReply|Content", "models/reply.rb:-"], ary[22])
    assert_parser(["SillyReply|Last read", "models/reply.rb:-"], ary[23])
    assert_parser(["SillyReply|Parent", "models/reply.rb:-"], ary[24])
    assert_parser(["SillyReply|Replies count", "models/reply.rb:-"], ary[25])
    assert_parser(["SillyReply|Title", "models/reply.rb:-"], ary[26])
    assert_parser(["SillyReply|Type", "models/reply.rb:-"], ary[27])
    assert_parser(["SillyReply|Written on", "models/reply.rb:-"], ary[28])

    assert_parser(["topic", "models/reply.rb:-"], ary[29])
  end

  def test_untranslate
    GetText::ActiveRecordParser.target?("models/book.rb")
    ary = GetText::ActiveRecordParser.parse("models/book.rb")
    ary.sort!{|a, b| a[0].downcase <=> b[0].downcase}
    assert_equal(4, ary.size)
    assert_parser(["book", "models/book.rb:-"], ary[0])
    assert_parser(["Book|Created at", "models/book.rb:-"], ary[1])
    assert_parser(["Book|Price", "models/book.rb:-"], ary[2])
    assert_parser(["Book|Updated at", "models/book.rb:-"], ary[3])
  end

  def test_untranslate_all
    GetText::ActiveRecordParser.target?("models/user.rb")
    ary = GetText::ActiveRecordParser.parse("models/user.rb")
    assert_equal(0, ary.size)
  end

  def test_abstract_class
    ary = GetText::ActiveRecordParser.parse("models/wizard.rb")
    assert_equal(0, ary.size)
  end
end
