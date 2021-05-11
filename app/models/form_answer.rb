# frozen_string_literal: true

# codigo referente a estoria de usuario "EU 10"
class FormAnswer < ApplicationRecord
  validates :form_id, presence: true
  validates :answers, presence: true

  belongs_to :user, optional: true
  belongs_to :form
end
