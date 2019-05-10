module HC
  module Presenter
    module HelperMethods

      def present(object, klass: nil, method: nil, options: {})
        HC::Presenter.present(object, klass: klass, controller_context: self, method: method, options: options)
      end

    end
  end
end
