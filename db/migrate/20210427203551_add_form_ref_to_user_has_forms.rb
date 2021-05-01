# frozen_string_literal: true

class AddFormRefToUserHasForms < ActiveRecord::Migration[6.0] # rubocop:todo Style/Documentation
  def change
    add_reference :user_has_forms, :form, null: false, foreign_key: true
  end
end
