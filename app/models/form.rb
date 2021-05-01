# frozen_string_literal: true

class Form < ApplicationRecord
  validates :question, presence: true

  has_many :user_has_form
  has_many :users, through: :user_has_form
  belongs_to :user
  has_many :form_answers
end
