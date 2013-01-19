=begin

 PureMVC MultiCore - Copyright(c) 2006-08 Futurescale, Inc., Some rights reserved.
 Your reuse is governed by the Creative Commons Attribution 3.0 United States License

 Ruby Port by Oliver Feldt

=end

module PureMVC
  module MultiCore
    # A Base Notifier implementation.
    #
    # MacroCommand, Command, Mediator and Proxy all have a need to send Notifications.
    # The Notifier interface provides a common method called
    # send_notification that relieves implementation code of
    # the necessity to actually construct Notifications.
    #
    # The Notifier class, which all of the above mentioned classes
    # extend, provides an initialized reference to the Facade
    # Multiton, which is required for the convienience method
    # for sending Notifications, but also eases implementation as these
    # classes have frequent Facade interactions and usually require
    # access to the facade anyway.
    #
    # NOTE: In the MultiCore version of the framework, there is one caveat to
    # notifiers, they cannot send notifications or reach the facade until they
    # have a valid multiton_key.
    #
    # The multiton_key is set:
    # * on a Command when it is executed by the Controller
    # * on a Mediator is registered with the View
    # * on a Proxy is registered with the Model.
    class Notifier
      attr_accessor :multiton_key

      # Create and send an Notification.
      #
      # Keeps us from having to construct new Notification instances in our implementation code.
      def send_notification(notification_name, body=nil, type=nil)
        facade.send_notification(notification_name, body, type) unless facade.nil?
      end

      # Initialize this Notifier instance.
      #
      # This is how a Notifier gets its multiton_key. 
      # Calls to send_notification or to access the
      # facade will fail until this method has been called.
      # Mediators, Commands or Proxies may override
      # this method in order to send notifications
      # or access the Multiton Facade instance as soon as possible.
      # They CANNOT access the facade in their constructors,
      # since this method will not yet have been called.
      def initialize_notifier(key)
        raise(Error::MultitonKeyError, Error::MultitonKeyError::WRONG_KEY_TYPE_MSG) unless key.kind_of? Symbol
        @multiton_key = key
      end

      # Return the Multiton Facade instance 
      def facade
        raise(Error::MultitonKeyError, Error::MultitonKeyError::NOTIFIER_MULTITON_MSG) unless @multiton_key
        Facade.instance(@multiton_key)
      end
    end
  end
end