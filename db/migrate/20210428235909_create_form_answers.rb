# frozen_string_literal: true

class CreateFormAnswers < ActiveRecord::Migration[6.0] # rubocop:todo Style/Documentation
  def change
    create_table :form_answers do |t|
      t.string :answers

      t.timestamps
    end
  end
end
