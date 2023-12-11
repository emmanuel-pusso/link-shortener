class LinkEphemeral < Link
    validates :visited, inclusion: [true, false]

    def meets_condition_for_display?
        !(self.visited)
    end
end
