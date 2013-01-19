require 'spec_helper'

module PureMVC
  module MultiCore
    describe Facade do
      include_context "singleton reset"

      subject { Facade }

      it_behaves_like "any multiton"

      it "should remove a Facade and all its Core-Actor instances by key" do
        created_facade = Facade.new(:key)

        Controller.should_receive(:remove_controller).with(:key).once
        Model.should_receive(:remove_model).with(:key).once
        View.should_receive(:remove_view).with(:key).once

        Facade.remove_core(:key)
        created_facade.should_not equal(Facade.instance(:key))
      end

      it "should initialize a Controller, Model and View with the same key" do
        Facade.new(:facade_key)

        lambda {
          Controller.new(:facade_key)
        }.should raise_error(Error::MultitonKeyError, 'Controller instance for this Multiton key already constructed!')
        lambda {
          Model.new(:facade_key)
        }.should raise_error(Error::MultitonKeyError, 'Model instance for this Multiton key already constructed!')
        lambda {
          View.new(:facade_key)
        }.should raise_error(Error::MultitonKeyError, 'View instance for this Multiton key already constructed!')
      end

      it "should send notifcations to observers" do
        facade = Facade.new(:key)

        command = mock(SimpleCommand)
        command.should_receive(:new).once.and_return(command)
        command.should_receive(:initialize_notifier).once
        command.should_receive(:execute).once

        mediator = mock(Mediator)
        mediator.should_receive(:name).at_least(:once).and_return(:mediator_name)
        mediator.should_receive(:initialize_notifier).once
        mediator.should_receive(:list_notification_interests).once.and_return([:notification_name])
        mediator.should_receive(:on_register).once
        mediator.should_receive(:handle_notification).once

        facade.register_command(:notification_name, command)
        facade.register_mediator(mediator)

        facade.send_notification(:notification_name, :type, :body)
      end

      it "should allow command registration, checking and removal" do
        facade = Facade.new(:key)
        command = mock(SimpleCommand)

        facade.register_command(:notification_name, command)
        facade.should have_command(:notification_name)
        facade.remove_command(:notification_name)
        facade.should_not have_command(:notification_name)
      end

      it "should allow proxy registration, checking and removal" do
        facade = Facade.new(:key)
        proxy = mock(Proxy)
        proxy.should_receive(:name).at_least(:once).and_return(:proxy_name)
        proxy.should_receive(:initialize_notifier).once
        proxy.should_receive(:on_register).once
        proxy.should_receive(:on_remove).once

        facade.register_proxy(proxy)
        facade.should have_proxy(proxy.name)
        facade.remove_proxy(proxy.name)
        facade.should_not have_proxy(proxy.name)
      end

      it "should retrieve a proxy by key" do
        facade = Facade.new(:key)
        created_proxy = mock(Proxy)
        created_proxy.should_receive(:name).at_least(:once).and_return(:proxy_name)
        created_proxy.should_receive(:initialize_notifier).once
        created_proxy.should_receive(:on_register).once

        facade.register_proxy(created_proxy)
        retrieved_proxy = facade.retrieve_proxy(created_proxy.name)
        created_proxy.should equal(retrieved_proxy)
      end

      it "should allow mediator registration, checking and removal" do
        facade = Facade.new(:key)
        notifications = []
        3.times { |i| notifications << :"notification_name_#{i}" }

        mediator = mock(Mediator)
        mediator.should_receive(:name).at_least(:once).and_return(:mediator_name)
        mediator.should_receive(:initialize_notifier).once
        mediator.should_receive(:list_notification_interests).twice.and_return(notifications)
        mediator.should_receive(:on_register).once
        mediator.should_receive(:on_remove).once

        facade.register_mediator(mediator)
        facade.should have_mediator(mediator.name)
        facade.remove_mediator(mediator.name)
        facade.should_not have_mediator(mediator.name)
      end

      it "should retrieve mediator by key" do
        facade = Facade.new(:key)
        mediator = mock(Mediator)
        mediator.should_receive(:name).at_least(:once).and_return(:mediator_name)
        mediator.should_receive(:initialize_notifier).once
        mediator.should_receive(:list_notification_interests).once.and_return([])
        mediator.should_receive(:on_register).once

        facade.register_mediator(mediator)
        facade.retrieve_mediator(mediator.name).should == mediator
      end

    end
  end
end
