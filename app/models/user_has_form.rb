class UserHasForm < ApplicationRecord
  belongs_to :user
  belongs_to :form
end
