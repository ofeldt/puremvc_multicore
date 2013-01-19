require 'spec_helper'

module PureMVC
  module MultiCore

    describe Model do
      include_context "singleton reset"

      subject { Model }

      it_behaves_like "any multiton"
      it_behaves_like "any core actor multiton"

      it "should register, check and remove proxies" do
        model = Model.new(:key)
        proxy = mock(Proxy)
        proxy.should_receive(:name).at_least(:once).and_return(:proxy_name)
        proxy.should_receive(:initialize_notifier).once
        proxy.should_receive(:on_register).once
        proxy.should_receive(:on_remove).once

        model.register_proxy(proxy)
        model.should have_proxy(proxy.name)
        model.remove_proxy(proxy.name)
        model.should_not have_proxy(proxy.name)
      end

      it "should retrieve a proxy by key" do
        model = Model.new(:key)
        proxy = mock(Proxy)
        proxy.should_receive(:name).at_least(:once).and_return(:proxy_name)
        proxy.should_receive(:initialize_notifier).once
        proxy.should_receive(:on_register).once

        model.register_proxy(proxy)
        model.retrieve_proxy(proxy.name).should == proxy
      end
      
    end
  end
end
