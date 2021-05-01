# frozen_string_literal: true

class AddUserRefToFormAnswers < ActiveRecord::Migration[6.0] # rubocop:todo Style/Documentation
  def change
    add_reference :form_answers, :user, null: false, foreign_key: true
  end
end
