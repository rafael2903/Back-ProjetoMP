# frozen_string_literal: true

class UserHasForm < ApplicationRecord
  belongs_to :user
  belongs_to :form
end
