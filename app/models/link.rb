require 'securerandom'

class Link < ApplicationRecord
    belongs_to :user
    validates :slug, presence: true, uniqueness: true
    validates :large_url, presence: true, format: {
    with: /\A(?:http|https|ftp):\/\/\S+\z/,
    message: "is not a valid URL"
  }

  # This method generate a unique slug, and assign it to user
  def generate_slug
    loop do
      self.slug = SecureRandom.alphanumeric(6).upcase

      # Check if the generated slug is unique
      break unless Link.exists?(slug: self.slug)
    end
  end

end
