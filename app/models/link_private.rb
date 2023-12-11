class LinkPrivate < Link
    validates :secret, presence: true

    def update_conditions
    end
end
