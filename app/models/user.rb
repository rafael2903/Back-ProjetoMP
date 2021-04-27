# frozen_string_literal: true

class User < ApplicationRecord
    validates :email, presence: true, uniqueness: true

    has_many :user_has_form
    has_many :forms, through: :user_has_form
    has_many :forms
end
