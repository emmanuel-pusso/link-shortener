class User < ApplicationRecord
    has_many :links, dependent: :destroy
    validates :password, presence: true
    validates :username, presence: true, uniqueness: true
    validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }, uniqueness: true
end
