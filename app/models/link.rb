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

  # checks if the link meets the condition to be displayed, each link type must implement it
  def meets_condition_for_display?
    raise NotImplementedError, "Subclasses must define `meets_condition_for_display?` method."
  end

  # checks if the link meets the condition to be displayed, each link type must implement it
  def update_conditions
    raise NotImplementedError, "Subclasses must define `update_conditions` method."
  end

end
