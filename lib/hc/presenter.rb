require "hc/presenter/version"

module HC
  module Presenter

    def self.present(object, klass: nil, controller_context: nil, method: nil, options: {})
      if object.nil?
        return object
      elsif object.is_a?(DateTime) || object.is_a?(Time)
        return object.to_formatted_s(:iso8601)
      elsif object.respond_to?(:count)
        content = object.collect{ |o| present(o, klass: klass, controller_context: controller_context, method: method, options: options) }
        return content
      else
        klass ||= "#{object.class}Presenter".constantize
        presenter_object = klass.new(object: object, controller_context: controller_context, options: options)
        if !method.nil? && presenter_object.respond_to?(method)
          presenter_object.send(method)
        else
          presenter_object.send(:format)
        end
      end
    end

  end
end
