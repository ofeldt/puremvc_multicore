require 'spec_helper'

module PureMVC
  module MultiCore

    describe Controller do
      include_context "singleton reset"

      subject { Controller }

      it_behaves_like "any multiton"
      it_behaves_like "any core actor multiton"

      it "should initialize a View with the same key" do
        Controller.new(:controller_key)
        lambda {
          View.new(:controller_key)
        }.should raise_error(Error::MultitonKeyError, 'View instance for this Multiton key already constructed!')
      end

      it "should register, check and remove commands" do
        controller = Controller.new(:key)
        command = mock(SimpleCommand)

        controller.register_command(:notification_name, command)
        controller.should have_command(:notification_name)
        controller.remove_command(:notification_name)
        controller.should_not have_command(:notification_name)
      end

      it "should execute a command" do
        controller = Controller.new(:key)
        command = mock(SimpleCommand)
        command.should_receive(:new).once.and_return(command)
        command.should_receive(:initialize_notifier).once
        command.should_receive(:execute).once

        notification = mock(Notification)
        notification.should_receive(:name).at_least(:once).and_return(:notification_name)

        controller.register_command(:notification_name, command)
        controller.execute_command(notification)
      end
      
    end
  end
end
