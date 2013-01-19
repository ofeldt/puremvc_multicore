=begin

 PureMVC MultiCore - Copyright(c) 2006-08 Futurescale, Inc., Some rights reserved.
 Your reuse is governed by the Creative Commons Attribution 3.0 United States License

 Ruby Port by Oliver Feldt

=end

module PureMVC
  module MultiCore
    # A base Mediator implementation.
    class Mediator < PureMVC::MultiCore::Notifier
      attr_reader :name, :view

      def initialize(name="Mediator", view=nil)
        @name = name
        @view = view
        @notification_handlers = {}
        initialize_mediator
      end

      # Initialize your Notification handler methods here, if neccessary
      def initialize_mediator
      end

      # List the Notification names this Mediator is interested in being notified of.
      def list_notification_interests
        @notification_handlers.keys
      end

      # Handle Notifications.
      #
      # Typically this will be handled in a switch statement,
      # with one 'case' entry per Notification the Mediator is interested in.
      def handle_notification(note)
        @notification_handlers[note.name].each { |handler_method| handler_method.call(note) }
      end

      # Add a Notification handler method for a specific Notification
      #
      # register an instance method of this Mediator for handling a Notification
      def add_notification_handler(notification_name, handler_method_name)
        @notification_handlers[notification_name] ||= []
        @notification_handlers[notification_name] << self.method(handler_method_name)
      end

      # Remove a previous added Notification handler
      #
      # unregister an instance method which was previously handling a certain Notification
      def remove_notification_handler(notification_name, handler_method_name)
        @notification_handlers[notification_name].delete(self.method(handler_method_name))
      end

      # Called by the View when the Mediator is registered
      def on_register
        #override if you want to do something on this event
      end

      # Called by the View when the Mediator is removed
      def on_remove
        #override if you want to do something on this event
      end
    end
  end
end