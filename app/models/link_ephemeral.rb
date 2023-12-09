class LinkEphemeral < Link
    validates :visited, inclusion: [true, false]
end
