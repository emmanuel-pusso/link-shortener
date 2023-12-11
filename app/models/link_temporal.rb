class LinkTemporal < Link
    validates :expires_at, presence: true
    validate :expires_is_not_in_the_past

    def meets_condition_for_display?
        self.expires_at > DateTime.current
    end

    def update_conditions
    end

    private

    def expires_is_not_in_the_past

        if (expires_at && expires_at < DateTime.current)
            errors.add :expires_at, 'DateTime cannot be in the past'
        end
    end
end
