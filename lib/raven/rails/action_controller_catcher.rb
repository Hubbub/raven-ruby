module Raven
  module Rails
    module ActionControllerCatcher
      def self.included(base)
        if base.method_defined?(:rescue_action_in_public)
          base.send(:alias_method, :rescue_action_in_public_without_raven, :rescue_action_in_public)
          base.send(:alias_method, :rescue_action_in_public, :rescue_action_in_public_with_raven)
        end
      end

      private

      def rescue_action_in_public_with_raven(exception)
        Raven.capture_exception(exception) do |evt|
          evt.interface :http do |int|
            int.from_rack(request.env)
          end
        end
        
        rescue_action_in_public_without_raven(exception)
      end
    end
  end
end
