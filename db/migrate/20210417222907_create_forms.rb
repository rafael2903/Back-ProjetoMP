# frozen_string_literal: true

class CreateForms < ActiveRecord::Migration[6.0] # rubocop:todo Style/Documentation
  def change
    create_table :forms do |t|
      t.string :question

      t.timestamps
    end
  end
end
