class CreateLinks < ActiveRecord::Migration[7.1]
  def change
    create_table :links do |t|
      t.belongs_to :user, null: false, foreign_key: { on_delete: :cascade }
      t.string :name
      t.string :large_url, null: false
      t.string :slug, null: false
      t.string :type, null: false

      t.timestamps
    end
    add_index :links, :slug
  end
end
