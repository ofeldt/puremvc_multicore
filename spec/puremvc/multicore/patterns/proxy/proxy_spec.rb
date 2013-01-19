require 'spec_helper'

module PureMVC
  module MultiCore

    describe Proxy do

      subject { Proxy.new(:key) }

      it_behaves_like "any notifier"

      it "should have a name" do
        subject.should respond_to(:name)
      end

      it "should provide a registration handler" do
        subject.should respond_to(:on_register)
      end
      it "should provide a removal handler" do
        subject.should respond_to(:on_remove)
      end

    end

  end
end
