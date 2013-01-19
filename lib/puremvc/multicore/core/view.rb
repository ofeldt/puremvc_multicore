=begin

 PureMVC MultiCore - Copyright(c) 2006-08 Futurescale, Inc., Some rights reserved.
 Your reuse is governed by the Creative Commons Attribution 3.0 United States License

 Ruby Port by Oliver Feldt

=end

module PureMVC
  module MultiCore
    # A Multiton View implementation.
    #
    # In PureMVC, the View class assumes these responsibilities:
    # * Maintain a cache of Mediator instances.
    # * Provide methods for registering, retrieving, and removing Mediators.
    # * Notifiying Mediators when they are registered or removed.
    # * Managing the observer lists for each Notification in the application.
    # * Providing a method for attaching Observers to an Notification's observer list.
    # * Providing a method for broadcasting an Notification.
    # * Notifying the Observers of a given Notification when it broadcast.
    class View
      attr_accessor :multiton_key

      @@instance_map = {}

      # This View implementation is a Multiton, 
      # so you should not call the constructor
      # directly, but instead call the static Multiton
      # Factory method View.instance(multiton_key)
      def initialize(key)
        raise(Error::MultitonKeyError, Error::MultitonKeyError::WRONG_KEY_TYPE_MSG) unless key.kind_of? Symbol
        raise(Error::MultitonKeyError, Error::MultitonKeyError::VIEW_MULTITON_MSG) unless @@instance_map[key].nil?
        @multiton_key = key
        @@instance_map[key] = self
        @mediator_map = {}
        @observer_map = {}
        initialize_view
      end

      # Initialize the Singleton View instance.
      #
      # Called automatically by the constructor, this
      # is your opportunity to initialize the Singleton
      # instance in your subclass without overriding the constructor.
      def initialize_view
      end

      # View Singleton Factory method.
      def self.instance(key)
        raise(Error::MultitonKeyError, Error::MultitonKeyError::WRONG_KEY_TYPE_MSG) unless key.kind_of? Symbol
        @@instance_map[key] = View.new(key) if @@instance_map[key].nil?
        @@instance_map[key]
      end

      # Register an Observer to be notified of Notifications with a given name.
      def register_observer(notification_name, observer)
        observers = @observer_map[notification_name]
        if observers.nil?
          @observer_map[notification_name] = observer
        else
          observers = Array(@observer_map[notification_name])
          observers << observer
          @observer_map[notification_name] = observers
        end
      end

      # Notify the Observers for a particular Notification.
      #
      # All previously attached Observers for this Notification's
      # list are notified and are passed a reference to the Notification in
      # the order in which they were registered.
      def notify_observers(notification)
        observers = Array(@observer_map[notification.name])
        observers.each { |observer| observer.notify_observer(notification) }
      end

      # Remove the observer for a given notify_context from an observer list for a given Notification name.
      def remove_observer(notification_name, observer)
        observers = @observer_map[notification_name]
        observers = Array(observers)
        @observer_map[notification_name] = observers.reject { |o| o.compare_notify_context(observer) }
        @observer_map.delete(notification_name) if observers.size.zero?
      end

      # Register an Mediator instance with the View.
      #
      # Registers the Mediator so that it can be retrieved by name,
      # and further interrogates the Mediator for its
      # Notification interests.
      # If the Mediator returns any Notification
      # names to be notified about, an Observer is created encapsulating
      # the Mediator instance's handleNotification method
      # and registering it as an Observer for all Notifications the
      # Mediator is interested in.
      def register_mediator(mediator)
        unless @mediator_map[mediator.name]
          mediator.initialize_notifier(@multiton_key)
          @mediator_map[mediator.name] = mediator
          observer = Observer.new(:handle_notification, mediator)
          mediator.list_notification_interests.each do |interest|
            register_observer(interest, observer)
          end
          mediator.on_register
        end
      end

      # Retrieve an Mediator from the View.
      def retrieve_mediator(mediator_name)
        @mediator_map[mediator_name]
      end

      # Remove an Mediator from the View.
      def remove_mediator(mediator_name)
        mediator = @mediator_map[mediator_name]
        if mediator
          mediator.list_notification_interests.each do |interest|
            remove_observer(interest, mediator)
          end
          @mediator_map.delete(mediator_name)
          mediator.on_remove
        end
        mediator
      end

      # Check if a Mediator is registered or not
      def has_mediator?(mediator_name)
        !@mediator_map[mediator_name].nil?
      end

      # Remove an View instance
      def self.remove_view(key)
        @@instance_map.delete(key)
      end
    end
  end
end