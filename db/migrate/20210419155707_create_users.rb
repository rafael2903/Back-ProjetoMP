# frozen_string_literal: true

class CreateUsers < ActiveRecord::Migration[6.0] # rubocop:todo Style/Documentation
  def change
    create_table :users do |t|
      t.string :email
      t.string :password
      t.boolean :is_admin

      t.timestamps
    end
  end
end
