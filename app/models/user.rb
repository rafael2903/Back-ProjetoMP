# frozen_string_literal: true

# codigo referente a estoria de usuario "EU 01"
class User < ApplicationRecord
  validates :email, presence: true, uniqueness: true
  validates :password, presence: true

  has_many :user_has_form
  has_many :forms, through: :user_has_form
  has_many :forms
  has_many :form_answers
end
