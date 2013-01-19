=begin

 PureMVC MultiCore - Copyright(c) 2006-08 Futurescale, Inc., Some rights reserved.
 Your reuse is governed by the Creative Commons Attribution 3.0 United States License

 Ruby Port by Oliver Feldt

=end

module PureMVC
  module MultiCore
    # A Multiton Controller implementation.
    #
    # In PureMVC, the Controller class follows the
    # 'Command and Controller' strategy, and assumes these responsibilities:
    # * Remembering which Commands are intended to handle which Notifications.
    # * Registering itself as an Observer withthe View for each Notification that it has an Command mapping for.
    # * Creating a new instance of the proper Commandto handle a given Notification when notified by the View.
    # * Calling the Command's executemethod, passing in the Notification.
    #
    # Your application must register Commands with the Controller.
    # The simplest way is to subclass Facade,
    # and use its initialize_controller method to add your registrations.
    class Controller
      attr_accessor :multiton_key
 
      @@instance_map = {}

      # This Controller implementation is a Multiton, 
      # so you should not call the constructor
      # directly, but instead call the static Factory method,
      # passing the unique key for this instance Controller.instance(multiton_key)
      def initialize(key)
        raise(Error::MultitonKeyError, Error::MultitonKeyError::WRONG_KEY_TYPE_MSG) unless key.kind_of? Symbol
        raise(Error::MultitonKeyError, Error::MultitonKeyError::CONTROLLER_MULTITON_MSG) unless @@instance_map[key].nil?
        @multiton_key = key
        @@instance_map[key] = self
        @command_map = {}
        initialize_controller
      end

      # Initialize the Multiton Controller instance.
      #
      # Called automatically by the constructor.
      # Note that if you are using a subclass of View
      # in your application, you should <i>also</i> subclass Controller
      # and override the initialize_controller method in the following way:
      #  def initialize_controller()
      #    @view = View.instance(@multiton_key)
      #  end
      def initialize_controller
        @view = View.instance(@multiton_key)
      end

      # Controller Multiton Factory method.
      def self.instance(key)
        raise(Error::MultitonKeyError, Error::MultitonKeyError::WRONG_KEY_TYPE_MSG) unless key.kind_of? Symbol
        @@instance_map[key] = Controller.new(key) if @@instance_map[key].nil?
        @@instance_map[key]
      end

      # If an Command has previously been registered 
      # to handle a the given Notification, then it is executed.
      def execute_command(notification)
        return unless @command_map[notification.name]
        command = @command_map[notification.name].new
        command.initialize_notifier(@multiton_key)
        command.execute(notification)
      end
      
      # Register a particular Command class as the handler for a particular Notification.
      #
      # If an Command has already been registered to handle Notifications with this name,
      # it is no longer used, the new Command is used instead.
      # The Observer for the new Command is only created if this the
      # first time an Command has been regisered for this Notification name.
      def register_command(notification_name, command_class)
        @view.register_observer(notification_name, Observer.new(:execute_command, self))
        @command_map[notification_name] = command_class
      end

      # Check if a Command is registered for a given Notification
      def has_command?(notification_name)
        !@command_map[notification_name].nil?
      end

      # Remove a previously registered Command to Notification mapping.
      def remove_command(notification_name)
        @view.remove_observer(notification_name, self)
        @command_map.delete(notification_name)
      end

      # Remove an Controller instance
      def self.remove_controller(key)
        @@instance_map.delete(key)
      end
    end
  end
end
