class AddVisitedToLinks < ActiveRecord::Migration[7.1]
  def change
    add_column :links, :visited, :boolean, null:false, default: false
  end
end