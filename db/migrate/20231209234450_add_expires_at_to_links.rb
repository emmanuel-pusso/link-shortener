class AddExpiresAtToLinks < ActiveRecord::Migration[7.1]
  def change
    add_column :links, :expires_at, :datetime
  end
end