module Admin
  class ApplicationController < ApplicationController
    include Pundit::Authorization
    include PunditAuthorable

    layout "admin/layouts/application"

    protected

    def render_turbo_errors(record, in_turbo_frame: "errors")
      [turbo_stream.update(in_turbo_frame, partial: "admin/layouts/errors", locals: { record: })]
    end
  end
end
