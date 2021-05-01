# frozen_string_literal: true

class CreateUserHasForms < ActiveRecord::Migration[6.0] # rubocop:todo Style/Documentation
  def change
    create_table :user_has_forms, &:timestamps
  end
end
