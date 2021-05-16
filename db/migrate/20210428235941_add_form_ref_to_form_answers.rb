# frozen_string_literal: true

class AddFormRefToFormAnswers < ActiveRecord::Migration[6.0]
  def change
    add_reference :form_answers, :form, null: false, foreign_key: true
  end
end
