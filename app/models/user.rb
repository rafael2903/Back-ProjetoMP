# frozen_string_literal: true

# codigo referente a estoria de usuario "EU 01"
class User < ApplicationRecord
  validates :email, presence: true, uniqueness: true

  has_many :user_has_form, dependent: :destroy
  has_many :forms, through: :user_has_form
  has_many :forms, dependent: :destroy
  has_many :form_answers, dependent: :destroy
end
