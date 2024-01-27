class Visit < ApplicationRecord
    belongs_to :link
    validates :visited_at, presence: true
    validates :ip_address, presence: true
    validate :valid_ip_address?

    private

    def valid_ip_address? 
        return unless ip_address.present?

        unless ip_address.match?(/\A(?:[0-9]{1,3}\.){3}[0-9]{1,3}\z/)
            errors.add(:ip_address, 'is not a valid IP address format')
        end
    end

end