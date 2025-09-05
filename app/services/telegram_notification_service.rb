# frozen_string_literal: true

require "telegram/bot"

class TelegramNotificationService
  def initialize(params)
    @params = params[:request]
  end

  def call
    send_notification if valid_telegram_credentials?
  end

  private

  def send_notification
    bot = Telegram::Bot::Client.new(telegram_token)
    bot.api.send_message(chat_id:, text: build_message, parse_mode: "HTML")
  rescue StandardError => e
    Rails.logger.error("Error sending notification: #{e.message}")
  end

  def build_message
    parts = []
    parts << "📩 Новий запит з форми!"
    parts << "👤 Ім’я: #{@params[:name]}" if @params[:name].present?
    parts << "📞 Телефон: #{@params[:phone]}" if @params[:phone].present?
    parts << "📃 Текст: #{@params[:message]}" if @params[:message].present?
    parts.join("\n")
  end

  def valid_telegram_credentials?
    telegram_token.present? && chat_id.present?
  end

  def telegram_token
    @telegram_token ||= Rails.application.credentials.dig(:telegram, :token)
  end

  def chat_id
    @chat_id ||= Rails.application.credentials.dig(:telegram, :chat_id).to_i
  end
end
