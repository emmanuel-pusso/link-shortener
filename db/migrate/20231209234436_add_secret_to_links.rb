class AddSecretToLinks < ActiveRecord::Migration[7.1]
  def change
    add_column :links, :secret, :string
  end
end