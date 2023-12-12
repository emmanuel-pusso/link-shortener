class LinkTemporal < Link
    validates :expires_at, presence: true
    validate :expires_is_not_in_the_past

    def meets_condition_for_display?
        if self.expires_at > DateTime.current
            result = { success: true }
        else
            result = { success: false, http_status: 404 }
        end

        result
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
