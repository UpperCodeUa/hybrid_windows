module Admin
  class SolidQueueAuthorizerController < Admin::ApplicationController
    before_action :authorize_policy

    def authorize_policy
      authorize :solid_queue_authorizer, policy_class: SolidQueueAuthorizerPolicy
    end

    private

    def user_not_authorized
      respond_to do |format|
        format.any(:html, :turbo_stream) do
          redirect_to main_app.root_url, alert: I18n.t("flash.unauthorized")
        end
      end
    end
  end
end
