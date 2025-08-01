module TurboFlashable
  extend ActiveSupport::Concern

  protected

  def notice_turbo_flash(message)
    flash.now[:notice] = message
    [turbo_stream.append("flash", partial: "layouts/flash")]
  end

  def alert_turbo_flash(message)
    flash.now[:alert] = message
    [turbo_stream.append("flash", partial: "layouts/flash")]
  end
end
