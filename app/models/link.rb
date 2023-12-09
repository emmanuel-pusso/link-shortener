class Link < ApplicationRecord
    belongs_to :user
    validates :slug, presence: true, uniqueness: true
    validates :large_url, presence: true, format: {
    with: /\A(?:http|https|ftp):\/\/\S+\z/,
    message: "is not a valid URL"
  }
end
