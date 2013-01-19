=begin

 PureMVC MultiCore - Copyright(c) 2006-08 Futurescale, Inc., Some rights reserved.
 Your reuse is governed by the Creative Commons Attribution 3.0 United States License

 Ruby Port by Oliver Feldt

=end

module PureMVC
  module MultiCore
    # A base Command implementation.
    #
    # Your subclass should override the execute 
    # method where your business logic will handle the Notification.
    class SimpleCommand < PureMVC::MultiCore::Notifier
      # Fulfill the use-case initiated by the given Notification.
      # In the Command Pattern, an application use-case typically
      # begins with some user action, which results in an Notification being broadcast, which
      # is handled by business logic in the execute method of an Command.
      def execute(notification)
        #override if you want to do something on this event
      end
    end
  end
end