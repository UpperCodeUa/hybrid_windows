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

      create_kommo_lead(@request, request)

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

  # rubocop:disable Metrics/CyclomaticComplexity
  def create_kommo_lead(local_request, controller_request)
    domain = "perfectgroupcrm.kommo.com"
    token = <<~TOKEN.delete("\n")
      eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImp0aSI6ImViNTAyNmU2MWYzZWRk
      Mjg4ZDcyMmQ1NDE0M2Y3ODA1MTNlMzFlNzlkMDMwZWY4OTUxNWRjZThjYmIwNDA1
      ZThlZmNjZGMwMjI2YTk1YTUxIn0.eyJhdWQiOiJhNjMxMzY4Ni1lZGU3LTQ1YTIt
      OGMwNi1iMDhmZmVlOWIzZDEiLCJqdGkiOiJlYjUwMjZlNjFmM2VkZDI4OGQ3MjJk
      NTQxNDNmNzgwNTEzZTMxZTc5ZDAzMGVmODk1MTVkY2U4Y2JiMDQwNWU4ZWZjY2Rj
      MDIyNmE5NWE1MSIsImlhdCI6MTc2MTA2NTU2MywibmJmIjoxNzYxMDY1NTYzLCJle
      HAiOjE5MTg3NzEyMDAsInN1YiI6IjExOTI4MTM1IiwiZ3JhbnRfdHlwZSI6IiIsIm
      FjY291bnRfaWQiOjMzNDY5NDk5LCJiYXNlX2RvbWFpbiI6ImtvbW1vLmNvbSIsInZ
      lcnNpb24iOjIsInNjb3BlcyI6WyJjcm0iLCJmaWxlcyIsImZpbGVzX2RlbGV0ZSIs
      Im5vdGlmaWNhdGlvbnMiLCJwdXNoX25vdGlmaWNhdGlvbnMiXSwiaGFzaF91dWlkIj
      oiNzQxMDdiZGItNzkxYy00NDdjLTg2OTctNTAwNWQ1MGM2OTI4IiwidXNlcl9mbG
      FncyI6MCwiYXBpX2RvbWFpbiI6ImFwaS1nLmtvbW1vLmNvbSJ9.RPfP0PCar0PuZ3
      8IJV2TpRkAs1abdxbHk92L-Sg63NHj_475D11UvKmCrVq5npwUjJEAXnFAl4ol1ku
      q72uPcIv89IoqA3SPmKBX5edW_muWSTPhQ8LdGZ5Bc4rLdFn5bUzBiFNMsaP2-EgG
      nx60WXHB7H2EjiQUAjDba3k8t1QvlN5zFEFrpTk1PBKlSW0xWhtpjSokMWi09T6-I
      mipLi7v4hNe31K4f7-LjsXzJDGR5lZnwOSqSkPNb5xyOzs9dkgcKolRUvbPcwb1FK
      YM50KdPB5sS4PqJhreMJ70L7JEzMX7lxvz1GEzO0OQXQ6ZvghkOWjcqGjOR9EWdXo
      OTg
    TOKEN
    begin
      contact_data = [
        {
          name:                 local_request.name,
          custom_fields_values: [
            {
              field_code: "PHONE",
              values:     [{ value: local_request.phone }],
            },
          ],
        },
      ]

      uri_contacts = URI.parse("https://#{domain}/api/v4/contacts")
      contact_response = http_post(uri_contacts, contact_data, token)
      contact_id = contact_response.dig("_embedded", "contacts", 0, "id")

      # UTM
      utm = {}
      if controller_request.env["HTTP_REFERER"]
        ref = URI.parse(controller_request.env["HTTP_REFERER"])
        utm = URI.decode_www_form(ref.query || "").to_h if ref.query
      end

      field_map = {
        utm_content:  736_392,
        utm_medium:   736_394,
        utm_campaign: 736_396,
        utm_source:   736_398,
        utm_term:     736_400,
        utm_referrer: 736_402,
      }

      custom_fields_values = []
      field_map.each do |utm_key, field_id|
        value = utm[utm_key.to_s]
        next if value.blank?

        custom_fields_values << { field_id: field_id, values: [{ value: value }] }
      end

      # add comment
      custom_fields_values << { field_id: 742_952, values: [{ value: local_request.message }] }

      lead_data = [
        {
          name:                 "Заявка с сайта",
          price:                0,
          pipeline_id:          9_555_887,
          status_id:            74_151_751,
          _embedded:            { contacts: contact_id ? [{ id: contact_id }] : [] },
          custom_fields_values: custom_fields_values,
        },
      ]

      uri_leads = URI.parse("https://#{domain}/api/v4/leads")
      http_post(uri_leads, lead_data, token)
    rescue StandardError => e
      Rails.logger.error("Ошибка при создании лида в Kommo: #{e.message}")
      nil
    end
  end
  # rubocop:enable Metrics/CyclomaticComplexity

  def http_post(uri, data, token)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    req = Net::HTTP::Post.new(uri.path, {
      "Authorization" => "Bearer #{token}",
      "Content-Type"  => "application/json",
    },)
    req.body = data.to_json
    res = http.request(req)
    # Rails.logger.info("Kommo response: #{res.code} #{res.body}")
    JSON.parse(res.body)
  end
end
