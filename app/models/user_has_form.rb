# frozen_string_literal: true

# codigo referente a estoria de usuario "EU 10"
class UserHasForm < ApplicationRecord
  belongs_to :user
  belongs_to :form
end
