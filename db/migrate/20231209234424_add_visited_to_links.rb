class AddVisitedToLinks < ActiveRecord::Migration[7.1]
  def change
    add_column :links, :visited, :boolean, default: false
  end
end