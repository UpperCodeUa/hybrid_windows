require "net/http"
require "uri"
require "json"

class HomeController < ApplicationController
  before_action :build_request

  def index; end
  def catalog; end
  def calculator; end
  def contacts; end
  def products; end
  def product_page; end
  def alu_patio; end
  def alue_passive; end
  def glass; end
  def alu_style; end
  def alu_glass; end
  def blinds; end
  def alu_passive_doors; end
  def thankyou_request; end

  def create_request
    unless verify_hcaptcha(params["g-recaptcha-response"])
      return redirect_back fallback_location: contacts_path,
                           alert: I18n.t("confirmation.fail_request")
    end

    @request = Request.new(request_params)

    if @request.save
      TelegramNotificationService.new(params).call if Rails.env.production?

      create_kommo_lead(@request)

      redirect_to thank_you_request_path, notice: I18n.t("confirmation.success_request")
    else
      redirect_back fallback_location: contacts_path, alert: I18n.t("confirmation.fail_request")
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

  # === Kommo CRM integration ===
  def create_kommo_lead(request)
    domain = "perfectgroupcrm.kommo.com"
    token = "Ogqwh9QXWwtLZPvrJVhwbqxquCf2vWbGt7nGmFAAJGB6VkD72XxpEYDwEkxH5sS1"

    # Создание контакта
    contact_data = [
      {
        name:                 request.name,
        custom_fields_values: [
          {
            field_code: "PHONE",
            values:     [{ value: request.phone }],
          },
        ],
      },
    ]

    uri_contacts = URI("https://#{domain}/api/v4/contacts")
    contact_response = http_post(uri_contacts, contact_data, token)
    contact_id = contact_response.dig("_embedded", "contacts", 0, "id")

    lead_data = [
      {
        name:                 "Заявка с сайта",
        price:                0,
        pipeline_id:          9_555_887,
        status_id:            73_737_591,
        _embedded:            {
          contacts: contact_id ? [{ id: contact_id }] : [],
        },
        custom_fields_values: [
          {
            field_name: "Комментарий",
            values:     [{ value: request.message }],
          },
        ],
      },
    ]

    uri_leads = URI("https://#{domain}/api/v4/leads")
    http_post(uri_leads, lead_data, token)
  rescue StandardError => e
    Rails.logger.error "Ошибка при создании лида в Kommo: #{e.message}"
  end

  def http_post(uri, data, token)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    req = Net::HTTP::Post.new(uri.path, {
      "Authorization" => "Bearer #{token}",
      "Content-Type"  => "application/json",
    },)
    req.body = data.to_json
    res = http.request(req)
    JSON.parse(res.body)
  end
end
