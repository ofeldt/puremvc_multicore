require 'spec_helper'

module PureMVC
  module MultiCore

    describe View do
      include_context "singleton reset"

      subject { View }

      it_behaves_like "any multiton"
      it_behaves_like "any core actor multiton"

      it "should register, check and remove observers" do
        view = View.new(:key)
        observer = mock(Observer)
        observer.should_receive(:notify_observer).once
        observer.should_receive(:compare_notify_context).once.and_return(true)

        notification = mock(Notification)
        notification.should_receive(:name).at_least(:once).and_return(:notification_name)

        view.register_observer(notification.name, observer)
        view.notify_observers(notification)
        view.remove_observer(notification.name, observer)
        view.notify_observers(notification)
      end

      it "should register, check and remove mediators" do
        view = View.new(:key)
        notifications = []
        3.times { |i| notifications << :"notification_name_#{i}" }

        mediator = mock(Mediator)
        mediator.should_receive(:name).at_least(:once).and_return(:mediator_name)
        mediator.should_receive(:initialize_notifier).once
        mediator.should_receive(:list_notification_interests).twice.and_return(notifications)
        mediator.should_receive(:on_register).once
        mediator.should_receive(:on_remove).once

        view.register_mediator(mediator)
        view.should have_mediator(mediator.name)
        view.remove_mediator(mediator.name)
        view.should_not have_mediator(mediator.name)
      end

      it "should retrieve a mediator by key" do
        view = View.new(:key)
        mediator = mock(Mediator)
        mediator.should_receive(:name).at_least(:once).and_return(:mediator_name)
        mediator.should_receive(:initialize_notifier).once
        mediator.should_receive(:list_notification_interests).once.and_return([])
        mediator.should_receive(:on_register).once

        view.register_mediator(mediator)
        view.retrieve_mediator(mediator.name).should == mediator
      end
      
    end
  end
end
