require 'spec_helper'

module PureMVC
  module MultiCore
    describe Observer do

      it "should be created with callback-method and context" do
        context = mock("Context")
        lambda {
          Observer.new(:method, context)
        }.should_not raise_error
      end

      it "should call context with method-name saved om notify" do
        receiver = mock("Receiver")
        receiver.should_receive(:called_method).once

        notification = mock(Notification)

        observer = Observer.new(:called_method, receiver)
        observer.notify_observer(notification)
      end

      it "should compare delivered context with its own" do
        receiver = mock("Receiver")
        receiver2 = mock("Receiver")

        observer = Observer.new(:called_method, receiver)

        observer.compare_notify_context(receiver).should be_true
        observer.compare_notify_context(receiver2).should be_false
      end

    end
  end
end
