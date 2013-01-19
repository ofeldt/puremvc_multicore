=begin

 PureMVC MultiCore - Copyright(c) 2006-08 Futurescale, Inc., Some rights reserved.
 Your reuse is governed by the Creative Commons Attribution 3.0 United States License

 Ruby Port by Oliver Feldt

=end

module PureMVC
  module MultiCore
    # A base Command implementation that executes other Commands.
    # 
    # A MacroCommand maintains an list of
    # Command Class references called <i>SubCommands</i>.
    # When execute is called, the MacroCommand
    # instantiates and calls execute on each of its <i>SubCommands</i> turn.
    # Each <i>SubCommand</i> will be passed a reference to the original
    # Notification that was passed to the MacroCommand's execute method.
    # Unlike SimpleCommand, your subclass should not override execute,
    # but instead, should override the initialize_macro_command method,
    # calling add_sub_command once for each <i>SubCommand</i> to be executed.
    class MacroCommand < PureMVC::MultiCore::Notifier

      # You should not need to define a constructor,
      # instead, override the initialize_macro_command method.
      # If your subclass does define a constructor, be sure to call super().
      def initialize
        @sub_commands = []
        initialize_macro_command
      end

      # Initialize the MacroCommand.
      # In your subclass, override this method to 
      # initialize the MacroCommand's <i>SubCommand</i>
      # list with Command class references like this:
      #  def initialize_macro_command
      #    add_sub_command(MyCommandOne)
      #    add_sub_command(MyCommandTwo)
      #    add_sub_command(MyCommandThree)
      #  end
      # Note that <i>SubCommand</i>s may be any Command implementor,
      # MacroCommands or SimpleCommands are both acceptable.
      def initialize_macro_command
      end

      # Add a <i>SubCommand</i>.
      # The <i>SubCommands</i> will be called in First In/First Out (FIFO) order.
      def add_sub_command(command)
        @sub_commands << command
      end

      # Execute this MacroCommand's <i>SubCommands</i>.
      # The <i>SubCommands</i> will be called in First In/First Out (FIFO) order.
      def execute(notification)
        @sub_commands.each do |command|
          c = command.new()
          c.initialize_notifier(@multiton_key)
          c.execute(notification)
        end
      end
    end
  end
end