require 'spec_helper'

describe Crashdesk::Backtrace do

  before do
    @backtrace_basic = File.read(File.join(File.dirname(__FILE__), 'stubs', 'backtrace_basic.txt'))
  end

  context "parsing raw backtrace to Backtrace object composed of Lines" do
    it "backtrace as string" do
      backtrace = Crashdesk::Backtrace.parse(@backtrace_basic)

      backtrace.lines.length.should == 17
    end

    it "backtrace as array" do
      backtrace = Array(@backtrace_basic.split(/\n\s*/))
      backtrace = Crashdesk::Backtrace.parse(backtrace)

      backtrace.lines.length.should == 17
    end

    it "backtrace with caller object" do
      backtrace = Crashdesk::Backtrace.parse(caller)
      backtrace.lines.should_not be_empty
      backtrace.hash_id.should_not == 'd41d8cd98f00b204e9800998ecf8427e'
      backtrace.crc.should_not == '0'
    end

    it "backtrace with nil object" do
      backtrace = Crashdesk::Backtrace.parse(nil)
      backtrace.lines.should be_empty
      backtrace.to_s.should be_empty
      backtrace.hash_id.should == 'd41d8cd98f00b204e9800998ecf8427e'
      backtrace.crc.should == '0'
    end
  end

  context "stripping backtrace from project root path" do
    it "generate 2 hashes" do
      backtrace = Crashdesk::Backtrace.parse(@backtrace_basic)

      backtrace.hash_id.should == '00912f3bc04ea70cc305951c43c48332'
      backtrace.crc.should == '2467818820'
    end

    it "generate 2 hashes that must be unique" do
      backtrace = Crashdesk::Backtrace.parse(@backtrace_basic)
      backtrace_modified = Crashdesk::Backtrace.parse(@backtrace_basic + "1")

      backtrace.should_not == backtrace_modified
      backtrace.hash_id.should_not == backtrace_modified.hash_id
      backtrace.crc.should_not == backtrace_modified.crc
    end
  end

  context "serialization" do
    it "should generate as array of lines" do
      backtrace = Crashdesk::Backtrace.parse(@backtrace_basic)
      backtrace.to_a.length.should == 17
    end
  end

end
