class Visit < ApplicationRecord
    belongs_to :link
    validates :visited_at, presence: true
    validates :ip_address, presence: true
    validate :valid_ip_address?

    scope :byLink , -> (link_id) {where(link_id:link_id)}
    scope :groupByDate , ->  { group(:visited_at).count }
    scope :byIpAdress,  -> (ip_address) {where('ip_address LIKE ?', "%#{ip_address}%")}

    scope :minDate, -> {minimum(:visited_at).strftime("%Y-%m-%d")}

    scope :byDateRange, ->(start_date, end_date) do
        from = start_date.present? ? start_date : minDate
        to = end_date.present? ? end_date : Date.today.strftime("%Y-%m-%d")
        where(visited_at: from..to)
    end

    private

    def valid_ip_address? 
        return unless ip_address.present?

        unless ip_address.match?(/\A(?:[0-9]{1,3}\.){3}[0-9]{1,3}\z/)
            errors.add(:ip_address, 'is not a valid IP address format')
        end
    end

end