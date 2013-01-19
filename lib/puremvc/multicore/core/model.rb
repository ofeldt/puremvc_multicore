=begin

 PureMVC MultiCore - Copyright(c) 2006-08 Futurescale, Inc., Some rights reserved.
 Your reuse is governed by the Creative Commons Attribution 3.0 United States License

 Ruby Port by Oliver Feldt

=end

module PureMVC
  module MultiCore
    # A Multiton Model implementation.
    #
    # In PureMVC, the Model class provides access to model objects (Proxies) by named lookup.
    # The Model assumes these responsibilities:
    # * Maintain a cache of Proxy instances.
    # * Provide methods for registering, retrieving, and removing Proxy instances.
    #
    # Your application must register Proxy instances
    # with the Model. Typically, you use an
    # Command to create and register Proxy
    # instances once the Facade has initialized the Core actors.
    class Model
      attr_accessor :multiton_key

      @@instance_map = {}

      # This Model implementation is a Multiton, 
      # so you should not call the constructor
      # directly, but instead call the static Multiton
      # Factory method Model.instance(multiton_key)
      def initialize(key)
        raise(Error::MultitonKeyError, Error::MultitonKeyError::WRONG_KEY_TYPE_MSG) unless key.kind_of? Symbol
        raise(Error::MultitonKeyError, Error::MultitonKeyError::MODEL_MULTITON_MSG) unless @@instance_map[key].nil?
        @multiton_key = key
        @@instance_map[key] = self
        @proxy_map = {}
        initialize_model
      end

      # Initialize the Model instance.
      #
      # Called automatically by the constructor, this
      # is your opportunity to initialize the Singleton
      # instance in your subclass without overriding the constructor.
      def initialize_model
      end

      # Model Multiton Factory method.
      def self.instance(key)
        raise(Error::MultitonKeyError, Error::MultitonKeyError::WRONG_KEY_TYPE_MSG) unless key.kind_of? Symbol
        @@instance_map[key] = Model.new(key) if @@instance_map[key].nil?
        @@instance_map[key]
      end

      # Register an Proxy with the Model.
      def register_proxy(proxy)
        proxy.initialize_notifier(@multiton_key)
        @proxy_map[proxy.name] = proxy
        proxy.on_register
      end

      # Retrieve an Proxy from the Model.
      def retrieve_proxy(proxy_name)
        @proxy_map[proxy_name]
      end

      # Check if a Proxy is registered
      def has_proxy?(proxy_name)
        !@proxy_map[proxy_name].nil?
      end

      # Remove an Proxy from the Model.
      def remove_proxy(proxy_name)
        proxy = @proxy_map.delete(proxy_name)
        proxy.on_remove
        proxy
      end
      
      # Remove an Model instance
      def self.remove_model(key)
        @@instance_map.delete(key)
      end
    end
  end
end