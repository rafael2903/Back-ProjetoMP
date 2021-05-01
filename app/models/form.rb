# frozen_string_literal: true

# codigo referente a estoria de usuario "EU 04"
class Form < ApplicationRecord
  validates :question, presence: true

  has_many :user_has_form
  has_many :users, through: :user_has_form
  belongs_to :user
  has_many :form_answers
end
