require 'spec_helper'
require 'crashdesk/reporters/test'

describe Crashdesk::ReportManager do

  context "with predefined reporters" do
    before(:all) do
      crashlog_class = class MyCrashlog
                          def to_hash
                            {:name => 1, :string => 2}
                          end
                       end
    end

    before do
      @crashlog = MyCrashlog.new
    end

    it "and with Logger should print it with PP" do
      Crashdesk.should_receive(:log).with("{:name=>1, :string=>2}")
      @report_manager = Crashdesk::ReportManager.new([:logger])
      @report_manager.process(@crashlog)
    end

    it "and with Foo logger should return echo and also with logger call PP" do
      @report_manager = Crashdesk::ReportManager.new([:logger, :test])
      @report_manager.process(@crashlog).should eq([nil, {name:1,string:2}])
    end

    it "must accept also constants as argument" do
      @report_manager = Crashdesk::ReportManager.new([:logger, ::Crashdesk::Reporters::Test.new])
      @report_manager.process(@crashlog).should eq([nil, {name:1,string:2}])
    end

  end

end
