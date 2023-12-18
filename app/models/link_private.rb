class LinkPrivate < Link
    validates :secret, presence: true

    def meets_condition_for_display? (password = nil)
        return self.secret == password
    end

    def update_conditions
    end
end
