# frozen_string_literal: true

class FormAnswer < ApplicationRecord
  belongs_to :user
  belongs_to :form
end
