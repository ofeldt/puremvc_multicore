require 'spec_helper'

module PureMVC
  module MultiCore
    describe Notification do

      before(:each) do
        @notification = Notification.new(:notification_name, {:complex_body => :notification_body}, {:complex_type => :notification_type})
      end

      it "should have a name" do
        @notification.name.should ==(:notification_name)
      end

      it "should have a body" do
        @notification.body.should ==({:complex_body => :notification_body})
      end

      it "should have a type" do
        @notification.type.should ==({:complex_type => :notification_type})
      end

      it "should have a string representation" do
        notification_name = Regexp.escape("#{@notification.name}")
        notification_body = Regexp.escape("#{@notification.body.inspect}")
        notification_type = Regexp.escape("#{@notification.type.inspect}")

        @notification.to_s.should match(notification_name)
        @notification.to_s.should match(notification_body)
        @notification.to_s.should match(notification_type)
      end

    end
  end
end
