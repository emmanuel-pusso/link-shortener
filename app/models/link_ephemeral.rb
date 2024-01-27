class LinkEphemeral < Link
    validates :visited, inclusion: [true, false]

    def meets_condition_for_display? (password = nil)
        return !self.visited
    end

    def update_conditions (user_ip_address)
       super (user_ip_address)
       self.visited = true
       self.save
    end
end
