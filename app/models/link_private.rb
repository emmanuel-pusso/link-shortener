class LinkPrivate < Link
    validates :secret, presence: true
end
