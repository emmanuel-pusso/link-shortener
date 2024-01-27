require 'securerandom'

class Link < ApplicationRecord
    belongs_to :user
    has_many :visits, dependent: :destroy
    validates :slug, presence: true, uniqueness: true
    validates :large_url, presence: true, format: {
    with: /\A(?:http|https|ftp):\/\/\S+\z/,
    message: "is not a valid URL"
  }

  # perform this action right after calling new and before calling save
  before_validation :complete_information

  # This method generate a unique slug, and assign it to user
  def generate_slug
    loop do
      self.slug = SecureRandom.alphanumeric(6)

      # Check if the generated slug is unique
      break unless Link.exists?(slug: self.slug)
    end
  end

  # checks if the link meets the condition to be displayed, each link type must implement it
  def meets_condition_for_display? (password = nil)
    raise NotImplementedError, "Subclasses must define `meets_condition_for_display?` method."
  end

  # after verifying that the condition for the redirection is met, the visit is created 
  def update_conditions (user_ip_address)
    #creates a visit for the link I want to redirect, with the current date, and the ip address from which the request was made
    Link.find_by(slug: self.slug).visits.create(visited_at: Date.today, ip_address: user_ip_address)
  end

  private

    def complete_information
      if self.slug.nil?
        # Set the slug (automatically generated on the model) to the new link
        generate_slug
      end
    end

end
