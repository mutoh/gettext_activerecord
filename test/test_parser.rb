require 'helper'

require 'gettext_activerecord/tools'

class TestGetTextParser < Test::Unit::TestCase
  def test_class
    GetText::ActiveRecordParser.target?("models/topic.rb")
    ary = GetText::ActiveRecordParser.parse("models/topic.rb")
    assert_equal(14, ary.size)
    assert_equal(["topic", "models/topic.rb:-"], ary[0])
    assert_equal(["Topic|Title", "models/topic.rb:-"], ary[1])
    assert_equal(["Topic|Author name", "models/topic.rb:-"], ary[2])
    assert_equal(["Topic|Author email address", "models/topic.rb:-"], ary[3])
    assert_equal(["Topic|Written on", "models/topic.rb:-"], ary[4])
    assert_equal(["Topic|Bonus time", "models/topic.rb:-"], ary[5])
    assert_equal(["Topic|Last read", "models/topic.rb:-"], ary[6])
    assert_equal(["Topic|Content", "models/topic.rb:-"], ary[7])
    assert_equal(["Topic|Approved", "models/topic.rb:-"], ary[8])
    assert_equal(["Topic|Replies count", "models/topic.rb:-"], ary[9])
    assert_equal(["Topic|Parent", "models/topic.rb:-"], ary[10])
    assert_equal(["Topic|Type", "models/topic.rb:-"], ary[11])
    assert_equal(["Topic|Terms of service", "models/topic.rb:35"], ary[12])
    assert_equal(["must be abided", "models/topic.rb:36"], ary[13])
  end

  def test_subclass
    GetText::ActiveRecordParser.target?("models/reply.rb")
    ary = GetText::ActiveRecordParser.parse("models/reply.rb")
    ary.sort!{|a, b| a[0].downcase <=> b[0].downcase}

    assert_equal(30, ary.size)
    assert_equal(["Empty", "models/reply.rb:16", "models/reply.rb:20"], ary[0])
    assert_equal(["is Content Mismatch", "models/reply.rb:25"], ary[1])
    assert_equal(["is Wrong Create", "models/reply.rb:30"], ary[2])
    assert_equal(["is Wrong Update", "models/reply.rb:34"], ary[3])
    assert_equal(["reply", "models/reply.rb:-"], ary[4])
    assert_equal(["Reply|Approved", "models/reply.rb:-"], ary[5])
    assert_equal(["Reply|Author email address", "models/reply.rb:-"], ary[6])
    assert_equal(["Reply|Author name", "models/reply.rb:-"], ary[7])
    assert_equal(["Reply|Bonus time", "models/reply.rb:-"], ary[8])
    assert_equal(["Reply|Content", "models/reply.rb:-"], ary[9])
    assert_equal(["Reply|Last read", "models/reply.rb:-"], ary[10])
    assert_equal(["Reply|Parent", "models/reply.rb:-"], ary[11])
    assert_equal(["Reply|Replies count", "models/reply.rb:-"], ary[12])
    assert_equal(["Reply|Title", "models/reply.rb:-"], ary[13])
    # this target is from N_().
    assert_equal(["Reply|Topic", "models/reply.rb:4"], ary[14])
    assert_equal(["Reply|Type", "models/reply.rb:-"], ary[15])
    assert_equal(["Reply|Written on", "models/reply.rb:-"], ary[16])

    assert_equal(["sillyreply", "models/reply.rb:-"], ary[17])
    assert_equal(["SillyReply|Approved", "models/reply.rb:-"], ary[18])
    assert_equal(["SillyReply|Author email address", "models/reply.rb:-"], ary[19])
    assert_equal(["SillyReply|Author name", "models/reply.rb:-"], ary[20])
    assert_equal(["SillyReply|Bonus time", "models/reply.rb:-"], ary[21])
    assert_equal(["SillyReply|Content", "models/reply.rb:-"], ary[22])
    assert_equal(["SillyReply|Last read", "models/reply.rb:-"], ary[23])
    assert_equal(["SillyReply|Parent", "models/reply.rb:-"], ary[24])
    assert_equal(["SillyReply|Replies count", "models/reply.rb:-"], ary[25])
    assert_equal(["SillyReply|Title", "models/reply.rb:-"], ary[26])
    assert_equal(["SillyReply|Type", "models/reply.rb:-"], ary[27])
    assert_equal(["SillyReply|Written on", "models/reply.rb:-"], ary[28])

    assert_equal(["topic", "models/reply.rb:-"], ary[29])
  end

  def test_untranslate
    GetText::ActiveRecordParser.target?("models/book.rb")
    ary = GetText::ActiveRecordParser.parse("models/book.rb")
    ary.sort!{|a, b| a[0].downcase <=> b[0].downcase}
    assert_equal(4, ary.size)
    assert_equal(["book", "models/book.rb:-"], ary[0])
    assert_equal(["Book|Created at", "models/book.rb:-"], ary[1])
    assert_equal(["Book|Price", "models/book.rb:-"], ary[2])
    assert_equal(["Book|Updated at", "models/book.rb:-"], ary[3])
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
