# frozen_string_literal: true

class AddUserRefToForms < ActiveRecord::Migration[6.0] # rubocop:todo Style/Documentation
  def change
    add_reference :forms, :user, null: true, foreign_key: true
  end
end
