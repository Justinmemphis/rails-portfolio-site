class Post < ApplicationRecord
  # Each post belongs to a user (the author)
  belongs_to :user

  # Validations ensure essential data is present
  validates :title, presence: true
  validates :body,  presence: true
end