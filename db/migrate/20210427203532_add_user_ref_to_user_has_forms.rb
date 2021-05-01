# frozen_string_literal: true

class AddUserRefToUserHasForms < ActiveRecord::Migration[6.0] # rubocop:todo Style/Documentation
  def change
    add_reference :user_has_forms, :user, null: false, foreign_key: true
  end
end
