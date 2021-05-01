# frozen_string_literal: true

# codigo referente a estoria de usuario "EU 10"
class FormAnswer < ApplicationRecord
  belongs_to :user
  belongs_to :form
end
