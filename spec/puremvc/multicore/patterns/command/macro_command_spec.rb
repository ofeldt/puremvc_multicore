require 'spec_helper'

module PureMVC
  module MultiCore

    describe MacroCommand do
      
      it_behaves_like "any notifier"
      
      it "should be executable" do
        simple_command = MacroCommand.new
        simple_command.should respond_to(:execute)
      end

      it "should register subcommands and call them when executed" do
        macro_command = MacroCommand.new

        notification = mock(Notification)

        child_command_one = mock(MacroCommand)
        child_command_two = mock(SimpleCommand)
        child_command_three = mock(SimpleCommand)

        child_command_one.should_receive(:new).and_return(child_command_one)
        child_command_one.should_receive(:initialize_notifier).once
        child_command_one.should_receive(:execute).once.with(notification)

        child_command_two.should_receive(:new).and_return(child_command_two)
        child_command_two.should_receive(:initialize_notifier).once
        child_command_two.should_receive(:execute).once.with(notification)

        child_command_three.should_receive(:new).and_return(child_command_three)
        child_command_three.should_receive(:initialize_notifier).once
        child_command_three.should_receive(:execute).once.with(notification)

        subcommands = [child_command_one, child_command_two, child_command_three]

        subcommands.each do |sub|
          macro_command.add_sub_command(sub)
        end

        macro_command.execute(notification)
      end

    end

  end
end
