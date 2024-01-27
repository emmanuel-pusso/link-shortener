class LinkTemporal < Link
    validates :expires_at, presence: true
    validate :expires_is_not_in_the_past

    def meets_condition_for_display? (password = nil)
        return self.expires_at > DateTime.current
    end

    private

    def expires_is_not_in_the_past

        if (expires_at && expires_at < DateTime.current)
            errors.add :expires_at, 'DateTime cannot be in the past'
        end
    end
end
