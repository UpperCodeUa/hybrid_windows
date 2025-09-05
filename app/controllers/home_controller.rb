class HomeController < ApplicationController
  before_action :build_request, only: %i[index contacts]

  def index; end
  def catalog; end
  def calculator; end
  def contacts; end
  def products; end
  def product_page; end

  def create_request
    unless verify_hcaptcha(params["g-recaptcha-response"])
      return redirect_back fallback_location: contacts_path,
                           alert:  I18n.t("fail_request")
    end

    @request = Request.new(request_params)

    if @request.save
      TelegramNotificationService.new(params).call if Rails.env.production?
      redirect_back fallback_location: contacts_path, notice: I18n.t("success_request")
    else
      redirect_back fallback_location: contacts_path, alert: I18n.t("fail_request")
    end
  end

  private

  def build_request
    @request = Request.new
  end

  def request_params
    params.expect(request: %i[name phone message])
  end

  def verify_hcaptcha(captcha_response)
    uri = URI.parse("https://hcaptcha.com/siteverify")
    http_response = Net::HTTP.post_form(
      uri,
      secret: Rails.application.credentials.dig(:hcaptcha, :secret_key),
      response: captcha_response,
    )

    result = JSON.parse(http_response.body)
    Rails.logger.info "hCaptcha verification result: #{result}"
    result["success"]
  end
end
