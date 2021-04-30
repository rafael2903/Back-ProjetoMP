class CreateUserHasForms < ActiveRecord::Migration[6.0]
  def change
    create_table :user_has_forms do |t|
      t.timestamps
    end
  end
end
