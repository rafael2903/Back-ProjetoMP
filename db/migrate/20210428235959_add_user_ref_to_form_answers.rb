# frozen_string_literal: true

class AddUserRefToFormAnswers < ActiveRecord::Migration[6.0]
  def change
    add_reference :form_answers, :user, null: true, foreign_key: true
  end
end
