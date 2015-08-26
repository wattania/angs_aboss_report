require 'doorkeeper/grape/authorization_decorator'

module Doorkeeper
  module Grape
    module Helpers
      extend ::Grape::API::Helpers
      include Doorkeeper::Rails::Helpers

      # endpoint specific scopes > parameter scopes > default scopes
      def doorkeeper_authorize!(*scopes)
        endpoint_scopes = env['api.endpoint'].options[:route_options][:scopes]
        scopes = if endpoint_scopes
                   Doorkeeper::OAuth::Scopes.from_array(endpoint_scopes)
                 elsif scopes && !scopes.empty?
                   Doorkeeper::OAuth::Scopes.from_array(scopes)
                 end

        super(*scopes)
      end

      def doorkeeper_render_error_with(error)
        status_code = case error.status
                      when :unauthorized
                        401
                      when :forbidden
                        403
                      end

        error!({ error: error.description }, status_code, error.headers)
      end

      private

      def doorkeeper_token
        @_doorkeeper_token ||= OAuth::Token.authenticate(
          decorated_request,
          *Doorkeeper.configuration.access_token_methods
        )
      end

      def decorated_request
        AuthorizationDecorator.new(request)
      end
    end
  end
end
