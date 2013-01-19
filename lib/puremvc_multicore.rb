require 'puremvc/multicore/patterns/facade/facade'
require 'puremvc/multicore/patterns/observer/observer'
require 'puremvc/multicore/patterns/observer/notification'
require 'puremvc/multicore/patterns/observer/notifier'
require 'puremvc/multicore/patterns/proxy/proxy'
require 'puremvc/multicore/patterns/mediator/mediator'
require 'puremvc/multicore/patterns/command/macro_command'
require 'puremvc/multicore/patterns/command/simple_command'
require 'puremvc/multicore/core/controller'
require 'puremvc/multicore/core/model'
require 'puremvc/multicore/core/view'
require 'puremvc/multicore/version'

#PureMVC is a lightweight framework for creating applications based upon the classic Model, View and Controller concept. 
module PureMVC
#   MultiCore Version
#
#   This variation supports modular programming, allowing the use of
#   independent program modules each with their own independent PureMVC 'Core'.
#
#   A Core is a set of the four main actors used in the Standard framework (Model, View, Controller and Facade)
#
#   This version of the framework uses Multitons instead of Singletons.
#   Rather than storing a single instance of the class, a Multiton stores a map of instances.
#   Each Core is referenced by an associated Multiton Key.
#
#   The MultiCore Version of the framework was developed due to
#   the widespread need for modular support in a world of ever-more ambitious
#   Rich Internet Applications which must load and unload large pieces of functionality at runtime.
#
#   For instance a PDA application might need to dynamically load and unload modules
#   for managing task list, calendar, email, contacts, and files.
  module MultiCore
    # Namespace for error and exception related classes
    module Error
      # Generic PureMVC MultiCore error
      class Error < RuntimeError; end

      # Error related to the MultitonKey
      class MultitonKeyError < Error
        WRONG_KEY_TYPE_MSG = 'Multiton key must be a Symbol!'

        FACADE_MULTITON_MSG = 'Facade instance for this Multiton key already constructed!'
        
        MODEL_MULTITON_MSG = 'Model instance for this Multiton key already constructed!'
        VIEW_MULTITON_MSG = 'View instance for this Multiton key already constructed!'
        CONTROLLER_MULTITON_MSG = 'Controller instance for this Multiton key already constructed!'

        NOTIFIER_MULTITON_MSG = 'Multiton key for this Notifier not yet initialized!'
      end
    end
  end
end
