require 'spec_helper'

module PureMVC
  module MultiCore

    describe Mediator do

      it "should have notification interests" do
        mediator = Mediator.new
        mediator.list_notification_interests.should be_kind_of(Array)
      end

      it "should have notification interests added per method" do
        mediator = Mediator.new

        mediator.stub!(:test_notification_one_handler_one)
        mediator.stub!(:test_notification_one_handler_two)
        mediator.stub!(:test_notification_two_handler_one)

        mediator.add_notification_handler(:test_notification_one, :test_notification_one_handler_one)
        mediator.add_notification_handler(:test_notification_one, :test_notification_one_handler_two)
        mediator.add_notification_handler(:test_notification_two, :test_notification_two_handler_one)

        mediator.list_notification_interests.length.should(equal(2))
        mediator.list_notification_interests.should(include(:test_notification_one))
        mediator.list_notification_interests.should(include(:test_notification_two))
      end

      it "should handle notifications" do
        mediator = Mediator.new
        mediator.should respond_to(:handle_notification)
      end

      it "should add notification handlers" do
        mediator = Mediator.new

        test_notification = Notification.new(:test_notification, :body, :type)
        test_notification.should_receive(:name).once.and_return(:test_notification)

        mediator.should_receive(:test_notification_handler).once.with(test_notification)
        mediator.should_receive(:test_notification_handler_two).once.with(test_notification)

        mediator.add_notification_handler(:test_notification, :test_notification_handler)
        mediator.add_notification_handler(:test_notification, :test_notification_handler_two)

        mediator.handle_notification(test_notification)
      end

      it "should remove notification handlers" do
        mediator = Mediator.new

        test_notification = Notification.new(:test_notification, :body, :type)
        test_notification.should_receive(:name).at_least(:once).and_return(:test_notification)

        mediator.should_receive(:test_notification_handler).twice.with(test_notification)
        mediator.should_receive(:test_notification_handler_two).once.with(test_notification)

        mediator.add_notification_handler(:test_notification, :test_notification_handler)
        mediator.add_notification_handler(:test_notification, :test_notification_handler_two)

        mediator.handle_notification(test_notification)

        mediator.remove_notification_handler(:test_notification, :test_notification_handler_two)
        
        mediator.handle_notification(test_notification)
      end

    end
    
  end
end
