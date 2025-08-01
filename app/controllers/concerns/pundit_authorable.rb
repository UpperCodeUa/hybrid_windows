module PunditAuthorable
  extend ActiveSupport::Concern

  included do
    rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

    after_action :verify_authorized
  end

  private

  def user_not_authorized
    respond_to do |format|
      format.any(:html, :turbo_stream) do
        redirect_to root_url, alert: I18n.t("flash.unauthorized")
      end
    end
  end
end
