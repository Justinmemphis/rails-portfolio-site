class User < ApplicationRecord
  # Securely stores passwords using bcrypt
  has_secure_password

  # Associations
  has_many :posts, dependent: :destroy

  # Validations
  validates :email, presence: true, uniqueness: true
  validates :password, presence: true, length: { minimum: 6 }, on: :create
end