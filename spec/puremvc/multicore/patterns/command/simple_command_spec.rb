require 'spec_helper'

module PureMVC
  module MultiCore

    describe SimpleCommand do
      
      it_behaves_like "any notifier"      

      it "should be executable" do
        simple_command = SimpleCommand.new
        simple_command.should respond_to(:execute)
      end

    end

  end
end
