=begin

 PureMVC MultiCore - Copyright(c) 2006-08 Futurescale, Inc., Some rights reserved.
 Your reuse is governed by the Creative Commons Attribution 3.0 United States License

 Ruby Port by Oliver Feldt

=end

module PureMVC
  module MultiCore
    # A base Multiton Facade implementation.
    class Facade
      attr_accessor :multiton_key

      @@instance_map = {}
 
      # This Facade implementation is a Multiton,
      # so you should not call the constructor
      # directly, but instead call the static Factory method,
      # passing the unique key for this instance
      # Facade.instance(multiton_key)
      def initialize(key)
        raise(Error::MultitonKeyError, Error::MultitonKeyError::WRONG_KEY_TYPE_MSG) unless key.kind_of? Symbol
        raise(Error::MultitonKeyError, Error::MultitonKeyError::FACADE_MULTITON_MSG) unless @@instance_map[key].nil?
        initialize_notifier(key)
        @@instance_map[key] = self
        @model, @view, @controller = nil, nil, nil
        initialize_facade
      end

      # Initialize the Multiton Facade instance.
      # Called automatically by the constructor. Override in your
      # subclass to do any subclass specific initializations. Be
      # sure to call super(), though.
      def initialize_facade
        initialize_model
        initialize_view
        initialize_controller
      end

      # Facade Multiton Factory method
      def self.instance(key)
        raise(Error::MultitonKeyError, Error::MultitonKeyError::WRONG_KEY_TYPE_MSG) unless key.kind_of? Symbol
        @@instance_map[key] = Facade.new(key) if @@instance_map[key].nil?
        @@instance_map[key]
      end

      # Initialize the Controller.
      #
      # Called by the initialize_facade method.
      # Override this method in your subclass of Facade if one or both of the following are true:
      # * You wish to initialize a different Controller.
      # * You have Commands to register with the Controller at startup.
      #
      # If you don't want to initialize a different Controller,
      # call super at the beginning of your method, then register Commands.
      def initialize_controller
        return unless @controller.nil?
        @controller = Controller.instance(@multiton_key)
      end

      # Initialize the Model.
      #
      # Called by the initializeFacade method.
      # Override this method in your subclass of Facade if one or both of the following are true:
      # * You wish to initialize a different Model.
      # * You have Proxys to register with the Model that do not retrieve a reference to the Facade at construction time.
      #
      # If you don't want to initialize a different Model,
      # call super() at the beginning of your method, then register Proxys.
      #
      # Note: This method is <i>rarely</i> overridden; in practice you are more
      # likely to use a Command to create and register Proxys with the Model,
      # since Proxys with mutable data will likely need to send Notifications and
      # thus will likely want to fetch a reference to the Facade during their construction.
      def initialize_model
        return unless @model.nil?
        @model = Model.instance(@multiton_key)
      end

      # Initialize the View.
      #
      # Called by the initializeFacade method.
      # Override this method in your subclass of Facade if one or both of the following are true:
      # * You wish to initialize a different View.
      # * You have Observers to register with the View
      #
      # If you don't want to initialize a different View,
      # call super() at the beginning of your method, then register Mediator instances.
      #
      # Note: This method is <i>rarely</i> overridden; in practice you are more
      # likely to use a Command to create and register Mediators with the View,
      # since Mediator instances will need to send Notifications and
      # thus will likely want to fetch a reference to the Facade during their construction.
      def initialize_view
        return unless @view.nil?
        @view = View.instance(@multiton_key)
      end

      # Register an Command with the Controller by Notification name.
      def register_command(name, command_class)
        @controller.register_command(name, command_class)
      end

      # Remove a previously registered Command to Notification mapping from the Controller.
      def remove_command(notification_name)
        @controller.remove_command(notification_name)
      end

      # Check if a Command is registered for a given Notification 
      def has_command?(notification_name)
        @controller.has_command?(notification_name)
      end

      # Register an Proxy with the Model by name.
      def register_proxy(proxy)
        @model.register_proxy(proxy)
      end

      # Retrieve an Proxy from the Model by name.
      def retrieve_proxy(proxy_name)
        @model.retrieve_proxy(proxy_name)
      end

      # Remove an Proxy from the Model by name.
      def remove_proxy(proxy_name)
        proxy = @model.remove_proxy(proxy_name) unless @model.nil?
        proxy
      end

      # Check if a Proxy is registered
      def has_proxy?(proxy_name)
        @model.has_proxy?(proxy_name)
      end

      # Register a Mediator with the View.
      def register_mediator(mediator)
        @view.register_mediator(mediator) unless @view.nil?
      end

      # Retrieve an Mediator from the View.
      def retrieve_mediator(mediator_name)
        @view.retrieve_mediator(mediator_name)
      end

      # Remove an Mediator from the View.
      def remove_mediator(mediator_name)
        mediator = @view.remove_mediator(mediator_name) unless @view.nil?
        mediator
      end

      # Check if a Mediator is registered or not
      def has_mediator?(mediator_name)
        @view.has_mediator?(mediator_name)
      end

      # Create and send an Notification.
      #
      # Keeps us from having to construct new Notification 
      # instances in our implementation code.
      def send_notification(notification_name, body=nil, type=nil)
        notify_observers(Notification.new(notification_name, body, type))
      end

      # Notify Observers.
      #
      # This method is left public mostly for backward 
      # compatibility, and to allow you to send custom
      # notification classes using the facade.
      # Usually you should just call send_notification
      # and pass the parameters, never having to
      # construct the notification yourself.
      def notify_observers(notification)
        @view.notify_observers(notification) unless @view.nil?
      end

      # Set the Multiton key for this facade instance.
      #
      # Not called directly, but instead from the 
      # constructor when instance is invoked.
      # It is necessary to be public in order to implement Notifier.
      def initialize_notifier(key)
        @multiton_key = key
      end

      # Check if a Core is registered or not
      def self.has_core?(key)
        !@@instance_map[key].nil?
      end

      # Remove a Core.
      #
      # Remove the Model, View, Controller and Facade instances for the given key.
      def self.remove_core(key)
        return unless has_core?(key)
        Model.remove_model(key)
        View.remove_view(key)
        Controller.remove_controller(key)
        @@instance_map.delete(key)
      end
    end
  end
end