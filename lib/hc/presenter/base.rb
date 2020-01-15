# frozen_string_literal: true
module Hc
  module Presenter

    # Creates a platform for other presenters to serialize objects into hashes
    #
    class Base

      # Initialization of required and optional instance variables
      #
      def initialize(object:, controller_context: nil, options: {})
        @object = object
        @options = options.try(:to_h).to_h.symbolize_keys
        @controller_context = controller_context
      end

      # Abstraction method for nicer top-level access to object context with a
      # friendly name, plus allow access to any options that were passed in.
      #
      def self.presents(name)
        define_method(name) do
          @object
        end
        define_method(:options) do
          @options
        end
        define_method(:controller_context) do
          @controller_context
        end
      end

      def present(object, klass: nil, options: nil, method: nil)
        if @controller_context
          @controller_context.present(object, klass: klass, options: options || @options, method: method)
        else
          Hc::Presenter.present(object, klass: klass, method: method, options: options)
        end
      end

      private

      # This method passes off missing methods to the controller context,
      # thus allowing us access to that controller's methods in the presenters.
      # This should be used with care, and should only really be used for
      # authorization control and permissions-based conditional content.
      #
      def method_missing(*args, &block)
        return nil unless @controller_context
        @controller_context.send(*args, &block)
      end

    end

  end
end
