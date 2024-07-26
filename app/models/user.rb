class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: JwtDenylist

  has_many :tasks, dependent: :destroy

  # Adicione validações se necessário
  validates :email, presence: true, uniqueness: true
  validates :password, presence: true
end
