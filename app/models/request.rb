# frozen_string_literal: true

class Request < ApplicationRecord
  validates :name,
            :phone,
            :message,
            presence: true
end
